package com.chonglepet.android.image;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.lang.ref.SoftReference;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.concurrent.ConcurrentHashMap;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.params.HttpParams;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.media.ThumbnailUtils;
import android.net.http.AndroidHttpClient;
import android.os.AsyncTask;
import android.os.Environment;
import android.os.Handler;
import android.provider.MediaStore.Video;
import android.widget.BaseAdapter;
import android.widget.ImageView;

/**
 * 位图操作辅助类
 * 
 * @author 陈永兵
 * 
 */
public class BitmapHelper {
	private static BitmapHelper instance = null;
	private static String folderPath = null;

	public static BitmapHelper getInstance() {
		if (null == instance) {
			instance = new BitmapHelper();
			folderPath = Environment.getExternalStorageDirectory().getPath() + "/chongle/img/";
			File file = new File(folderPath);
			file.mkdirs();
		}
		return instance;
	}

	private BitmapHelper() {
	}

	/**
	 * 获得合适的采样率
	 * 
	 * @param options
	 * @param minSideLength
	 *            图宽
	 * @param maxNumOfPixels
	 *            最大分辨率
	 * @return
	 */
	private static int computeSampleSize(BitmapFactory.Options options, int minSideLength, int maxNumOfPixels) {
		int initialSize = computeInitialSampleSize(options, minSideLength, maxNumOfPixels);
		int roundedSize;
		if (initialSize <= 8) {
			roundedSize = 1;
			while (roundedSize < initialSize) {
				roundedSize <<= 1;
			}
		} else {
			roundedSize = (initialSize + 7) / 8 * 8;
		}
		return roundedSize;
	}

	/**
	 * 初始化采样率
	 * 
	 * @param options
	 * @param minSideLength
	 *            图宽
	 * @param maxNumOfPixels
	 *            最大分辨率
	 * @return
	 */
	private static int computeInitialSampleSize(BitmapFactory.Options options, int minSideLength, int maxNumOfPixels) {
		double w = options.outWidth;
		double h = options.outHeight;
		int lowerBound = (maxNumOfPixels == -1) ? 1 : (int) Math.ceil(Math.sqrt(w * h / maxNumOfPixels));
		int upperBound = (minSideLength == -1) ? 128 : (int) Math.min(Math.floor(w / minSideLength), Math.floor(h / minSideLength));

		if (upperBound < lowerBound) {
			// return the larger one when there is no overlapping zone.
			return lowerBound;
		}
		if ((maxNumOfPixels == -1) && (minSideLength == -1)) {
			return 1;
		} else if (minSideLength == -1) {
			return lowerBound;
		} else {
			return upperBound;
		}

	}

	private static final int MAX_CAPACITY = 20;// 一级缓存的最大空间
	private static final long DELAY_BEFORE_PURGE = 10*60 * 1000;// 定时清理缓存   时间是10分钟  

	// 0.75是加载因子为经验值，true则表示按照最近访问量的高低排序，false则表示按照插入顺序排序
	private static HashMap<String, Bitmap> mFirstLevelCache = new LinkedHashMap<String, Bitmap>(MAX_CAPACITY / 2, 0.75f, true) {
		private static final long serialVersionUID = 1L;

		protected boolean removeEldestEntry(Entry<String, Bitmap> eldest) {
			if (size() > MAX_CAPACITY) {// 当超过一级缓存阈值的时候，将老的值从一级缓存搬到二级缓存
				mSecondLevelCache.put(eldest.getKey(), new SoftReference<Bitmap>(eldest.getValue()));
				return true;
			}
			return false;
		};
	};
	// 二级缓存，采用的是软应用，只有在内存吃紧的时候软应用才会被回收，有效的避免了oom
	private static ConcurrentHashMap<String, SoftReference<Bitmap>> mSecondLevelCache = new ConcurrentHashMap<String, SoftReference<Bitmap>>(MAX_CAPACITY / 2);

	// 定时清理缓存
	private Runnable mClearCache = new Runnable() {
		@Override
		public void run() {
			clear();
		}
	};
	private Handler mPurgeHandler = new Handler();

	// 重置缓存清理的timer
	private void resetPurgeTimer() {
		mPurgeHandler.removeCallbacks(mClearCache);
		mPurgeHandler.postDelayed(mClearCache, DELAY_BEFORE_PURGE);
	}

	/**
	 * 清理缓存
	 */
	private void clear() {
		 mFirstLevelCache.clear();
		 mSecondLevelCache.clear();
	}

	/**
	 * 返回缓存，如果没有则返回null
	 * 
	 * @param url
	 * @return
	 */
	public Bitmap getBitmapFromCache(String url) {
		if (null == url) {
			return null;
		}
		Bitmap bitmap = null;
		bitmap = getFromFirstLevelCache(url);// 从一级缓存中拿
		if (bitmap != null) {
			return bitmap;
		}
		bitmap = getFromSecondLevelCache(url);// 从二级缓存中拿
		return bitmap;
	}

	/**
	 * 从二级缓存中拿
	 * 
	 * @param url
	 * @return
	 */
	private Bitmap getFromSecondLevelCache(String url) {
		Bitmap bitmap = null;
		SoftReference<Bitmap> softReference = mSecondLevelCache.get(url);
		if (softReference != null) {
			bitmap = softReference.get();
			if (bitmap == null) {// 由于内存吃紧，软引用已经被gc回收了
				mSecondLevelCache.remove(url);
			}
		}
		return bitmap;
	}

	/**
	 * 从一级缓存中拿
	 * 
	 * @param url
	 * @return
	 */
	private Bitmap getFromFirstLevelCache(String url) {
		Bitmap bitmap = null;
		synchronized (mFirstLevelCache) {
			bitmap = mFirstLevelCache.get(url);
			if (bitmap != null) {// 将最近访问的元素放到链的头部，提高下一次访问该元素的检索速度（LRU算法）
				mFirstLevelCache.remove(url);
				mFirstLevelCache.put(url, bitmap);
			}
		}
		return bitmap;
	}

	/**
	 * 加载图片，如果缓存中有就直接从缓存中拿，缓存中没有就取本地，本地没有就下载
	 * 
	 * @param url
	 * @param adapter
	 * @param ImageView
	 */
	public void loadImage(String fullPath, String url, int resourceId, BaseAdapter adapter, ImageView iv) {
		resetPurgeTimer();
		
		Bitmap bitmap = getBitmapFromCache(url);// 从缓存中读取
		if (null == bitmap) {
			iv.setImageResource(resourceId);// 缓存没有设为默认图片
			ImageLoadTask imageLoadTask = new ImageLoadTask();
			imageLoadTask.execute(fullPath, url, resourceId, null, iv);
		} else {
			iv.setImageBitmap(bitmap);// 设为缓存图片
		}
	}

	public void loadImage(String fullPath, String url, int resourceId, ImageView iv) {
		resetPurgeTimer();
		
		Bitmap bitmap = getBitmapFromCache(url);// 从缓存中读取
		if (null == bitmap) {
			iv.setImageResource(resourceId);// 缓存没有设为默认图片
			ImageLoadTask imageLoadTask = new ImageLoadTask();
			imageLoadTask.execute(fullPath, url, resourceId, iv);
		} else {
			iv.setImageBitmap(bitmap);// 设为缓存图片
		}
	}

	/**
	 * 放入缓存
	 * 
	 * @param fullPath
	 * @param value
	 */
	public void addImage2Cache(String fullPath, Bitmap value) {
		if (value == null || fullPath == null) {
			return;
		}
		synchronized (mFirstLevelCache) {
			mFirstLevelCache.put(fullPath, value);
		}
	}

	class ImageLoadTask extends AsyncTask<Object, Void, Bitmap> {
		String fullPath;
		String url;
		int resourceId;
		BaseAdapter adapter;
		ImageView iv;

		@Override
		protected Bitmap doInBackground(Object... params) {
			fullPath = (String) params[0];
			url = (String) params[1];
			resourceId = (Integer) params[2];
			iv = (ImageView) params[3];
			Bitmap bitmap = null;
			
			// 如果传入的图片本地路径为NULL，则从url获取MD5加密文件名
			if (null == fullPath) {
				String imageName=url.substring(url.lastIndexOf("/")+1);
				fullPath = folderPath + imageName;
			}
			bitmap = loadImageFromLocal(fullPath);// 获取本地图片
			if (null != bitmap) {
				return bitmap;
			}

			bitmap = loadImageFromInternet(url);// 获取网络图片

			// 获取到网络图片后，按从url获取MD5加密文件名保存
			if (null != bitmap) {
				FileOutputStream out = null;
				try {
					out = new FileOutputStream(fullPath,false);// 文件存在则覆盖掉  
					bitmap.compress(Bitmap.CompressFormat.JPEG, 30, out);
				} catch (Exception e) {
					e.printStackTrace();
				} finally {
					if (null != out) {
						try {
							out.close();
						} catch (IOException e) {
						}
					}
				}
			}

			return bitmap;
		}

		@Override
		protected void onPostExecute(Bitmap result) {
			super.onPostExecute(result);
			if (result == null) {
				iv.setImageResource(resourceId);
				return;
			}
			addImage2Cache(url, result);// 放入缓存
			if (null != adapter) {
				adapter.notifyDataSetChanged();// 触发getView方法执行，这个时候getView实际上会拿到刚刚缓存好的图片
			}
			if (null != iv) {
				iv.setImageBitmap(result);
			}
		}

		@Override
		protected void onPreExecute() {
			super.onPreExecute();
			// 建立图片缓存文件夹
			String path = Environment.getExternalStorageDirectory().getPath() + "/chongle/img/";
			File file = new File(path);
			file.mkdirs();
		}

	}

	public Bitmap loadImageFromVideo(String fullPath) {
		Bitmap bmp = null;
		bmp = ThumbnailUtils.createVideoThumbnail(fullPath, Video.Thumbnails.MICRO_KIND);
		return bmp;
	}

	public static Bitmap loadImageFromLocal(String fullPath) {
		if (null == fullPath) {
			return null;
		}
		Bitmap bitmap = null;
		File file = new File(fullPath);
		if (file.isFile() && file.exists()) {
			BitmapFactory.Options opt = new BitmapFactory.Options();
			opt.inPreferredConfig = Bitmap.Config.RGB_565;
			opt.inPurgeable = true;
			opt.inJustDecodeBounds = true;
			BitmapFactory.decodeFile(fullPath, opt);
			opt.inSampleSize = computeSampleSize(opt, -1, 1280 * 1280); // 采样率
			opt.inJustDecodeBounds = false;
			bitmap = BitmapFactory.decodeFile(fullPath, opt);
		}
		return bitmap;
	}

	public static Bitmap loadImageFromInternet(String url) {
		Bitmap bitmap = null;
		HttpClient client = AndroidHttpClient.newInstance("Android");
		HttpParams params = client.getParams();
		HttpConnectionParams.setConnectionTimeout(params, 5000);
		HttpConnectionParams.setSocketBufferSize(params, 5000);
		HttpResponse response = null;
		InputStream inputStream = null;
		HttpGet httpGet = null;
		try {
			httpGet = new HttpGet(url);
			response = client.execute(httpGet);
			int stateCode = response.getStatusLine().getStatusCode();
			if (stateCode != HttpStatus.SC_OK) {
				return bitmap;
			}
			HttpEntity entity = response.getEntity();
			if (entity != null) {
				try {
					inputStream = entity.getContent();
					return bitmap = BitmapFactory.decodeStream(inputStream);
				} finally {
					if (inputStream != null) {
						inputStream.close();
					}
					entity.consumeContent();
				}
			}
		} catch (Exception e) {
			httpGet.abort();
			e.printStackTrace();
			return bitmap;
		} finally {
			((AndroidHttpClient) client).close();
		}
		return bitmap;
	}
	/**
	 * http获取网络图片
	 * @param imageurl
	 * @return  Bitmap
 	 */
	public Bitmap getImageBitmap(String imageurl){
		Bitmap bitmap=null;
		try {
			HttpClient httpClient=new DefaultHttpClient();
			HttpGet httpGet=new HttpGet(imageurl);
			HttpResponse httpResponse=httpClient.execute(httpGet);
			if(httpResponse.getStatusLine().getStatusCode()==HttpStatus.SC_OK){
				HttpEntity httpEntity=httpResponse.getEntity();
				InputStream inputStream=httpEntity.getContent();
				bitmap=BitmapFactory.decodeStream(inputStream);
				bitmap=ThumbnailUtils.extractThumbnail(bitmap, 120, 100);
				inputStream.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return bitmap;
	}
}
