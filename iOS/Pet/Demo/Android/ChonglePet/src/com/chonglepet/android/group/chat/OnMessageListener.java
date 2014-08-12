package com.chonglepet.android.group.chat;

import org.jivesoftware.smack.packet.Message;

/**
 * @author chen
 * 
 *  version其中OnContactStateListener是一个事件接口，代码如下：
 */
public interface OnMessageListener {
	/*
	 * @return 处理接收到的消息
	 */
	public void processMessage(Message message);
}
