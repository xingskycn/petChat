package com.chonglepet.android.httprequset;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.util.List;

import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.params.CoreConnectionPNames;
import org.apache.http.protocol.HTTP;
import org.apache.http.util.EntityUtils;
import org.json.JSONException;

import android.annotation.SuppressLint;
import android.graphics.Bitmap;
import android.os.Environment;
import android.os.StrictMode;
import android.util.Log;

import com.chonglepet.android.image.BitmapHelper;

@SuppressLint("NewApi")
public class HttpHelper {
	        
	private static final int READ_TIMEOUT = 15000;
	private static final int CONNECTION_TIMEOUT = 15000;
	private static final int DEFAULT_BUFF_SIZE = 1024*1024;
	private static final String TAG = "[UploadTools]:";

	private static HttpPost httpPost;

	public static void initHttpClient(String url) {
		
		httpPost=new HttpPost(url);

	}
	
	/**
	 * 根据参数进行请求
	 * @param paramer
	 * @return
	 */
	public static String execute(List<BasicNameValuePair> paramer){
		
		String jsonobject=null;
		
		try {
			HttpClient httpClient=new DefaultHttpClient();
			
			httpClient.getParams().setParameter(
					CoreConnectionPNames.CONNECTION_TIMEOUT, 5000);
			httpClient.getParams().setParameter(
					CoreConnectionPNames.SO_TIMEOUT, 15000);
			
			httpPost.setEntity(new UrlEncodedFormEntity(paramer, HTTP.UTF_8));
			
			HttpResponse httpResponse=httpClient.execute(httpPost);
			
			if(httpResponse.getStatusLine().getStatusCode()==HttpStatus.SC_OK){
				
				jsonobject= EntityUtils.toString(httpResponse.getEntity(),"UTF-8");
				
			}
			return jsonobject;
			
		} catch (ClientProtocolException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

		return null;
	}
	
	/**
	 *  文件上传 带参数的
	 * @throws MalformedURLException
	 * @throws ProtocolException
	 * @throws FileNotFoundException
	 * @throws IOException
	 * @throws JSONException 
	 */
	public static String uploadFile_Paramters(String requestKey,String value,String fileUploadUrl,String requerstKeyfilepath,String filePath)
	{
		StringBuilder imageUrl = new StringBuilder();  
        try {
			String lineEnd = "\r\n";  
			String twoHyphens = "--";  
			String boundary = "ahhjifeohiawf";
			String fileName=filePath.substring(filePath.lastIndexOf("/")+1);

			URL url = new URL(fileUploadUrl);
			HttpURLConnection httpURLConnection = (HttpURLConnection) url.openConnection(); 
			
			// 设置每次传输的流大小，可以有效防止手机因为内存不足崩溃  
			// 此方法用于在预先不知道内容长度时启用没有进行内部缓冲的 HTTP 请求正文的流。  
			httpURLConnection.setChunkedStreamingMode(128 * 1024);// 128K  
			
			// 允许输入输出流  
			httpURLConnection.setDoInput(true);  
			httpURLConnection.setDoOutput(true);  
			httpURLConnection.setUseCaches(false);  
			// 超时时间设置  
			httpURLConnection.setReadTimeout(READ_TIMEOUT);  
			httpURLConnection.setConnectTimeout(CONNECTION_TIMEOUT);  
			
			// 使用POST方法  
			httpURLConnection.setRequestMethod("POST");  
			//httpURLConnection.setRequestProperty("Connection", "Keep-alive");  
			httpURLConnection.setRequestProperty("Charset", "UTF-8");  
			httpURLConnection.setRequestProperty("Content-Type", "multipart/form-data;boundary=" + boundary);  
			
			
			httpURLConnection.connect();
			
			StrictMode.setThreadPolicy(new StrictMode.ThreadPolicy.Builder().detectDiskReads().detectDiskWrites().detectNetwork().penaltyLog().build());
			
			DataOutputStream dos = new DataOutputStream(httpURLConnection.getOutputStream());
			
			// 发送Param1
			dos.writeBytes(twoHyphens + boundary + lineEnd);  
			dos.writeBytes("Content-Disposition: form-data; name=\""+requestKey+"\"" + lineEnd);  
			dos.writeBytes(lineEnd);  
			dos.writeBytes(value);  
			dos.writeBytes(lineEnd); 
			
			// 发送<strong>文件</strong>  
			dos.writeBytes(twoHyphens + boundary + lineEnd);  
			dos.writeBytes("Content-Disposition: form-data; name=\""+requerstKeyfilepath+"\"; filename=\"" + fileName + "\"" + lineEnd);  
			dos.writeBytes(lineEnd);  
			String srcPath = filePath;
  
			FileInputStream fis = new FileInputStream(srcPath);  
			byte[] buffer = new byte[DEFAULT_BUFF_SIZE]; // 8k  
			int counter = 0;  
			int count = 0;  
			// 读取<strong>文件</strong>  
			while ((count = fis.read(buffer)) != -1) {  
			    dos.write(buffer, 0, count);  
			    counter += count;  

			} 
			System.out.println(counter);
			
			fis.close();          

			dos.writeBytes(lineEnd);  
			dos.writeBytes(twoHyphens + boundary + twoHyphens + lineEnd);// 最后多出"--"作为结束  
			
			//System.out.println(httpURLConnection.getResponseCode());
			System.setProperty("http.keepAlive", "false");
			if (httpURLConnection.getResponseCode() == HttpStatus.SC_OK) {  
			    BufferedReader reader = new BufferedReader(new InputStreamReader(httpURLConnection.getInputStream()), 8192);// 8k  
			    String line = null;  
			    try {  
			        while ((line = reader.readLine()) != null) {  
  
			        	imageUrl.append(line + "\n");  
			        }  
			        
			    } catch (IOException e) {  
			        e.printStackTrace();  
			    }  

  
			} else {  
			    Log.d(TAG, "Http request failed!");  
 
			}  
  
			if (httpURLConnection != null) {  
			    httpURLConnection.disconnect();  
			}  
			
			dos.flush();  
			dos.close();
			return imageUrl.toString();
			
		} catch (Exception e) {
			e.printStackTrace();
			return imageUrl.toString();
		}
	}
	
	/**
	 * 图片加载
	 * @param requestUrl
	 * @return
	 */
	public static Bitmap executeImageLoad(String requestUrl) {
		Bitmap bitmap=null;
		String imageUrl=requestUrl.substring(requestUrl.lastIndexOf("/")+1);
		
		String folderPath = Environment.getExternalStorageDirectory().getPath() + "/chongle/img/";
		
		String fullPath=folderPath+imageUrl;
		
		bitmap=BitmapHelper.loadImageFromLocal(fullPath);
		if(bitmap!=null){
			return bitmap;
		}
		
		bitmap=BitmapHelper.loadImageFromInternet(requestUrl);
		if (null != bitmap) {
			FileOutputStream out = null;
			try {
				out = new FileOutputStream(fullPath,false);
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
	
}
