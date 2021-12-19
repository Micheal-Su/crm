package com.bjpowernode.crm.utils;

public class ServiceFactory {
	
	public static Object getService(Object service){
//		目前为service增强的功能为提交事务
		return new TransactionInvocationHandler(service).getProxy();
		
	}
	
}
