package com.bjpowernode.crm.utils;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;

import org.apache.ibatis.session.SqlSession;

public class TransactionInvocationHandler implements InvocationHandler{
//	目标对象
	private Object target;
	
	public TransactionInvocationHandler(Object target){
		
		this.target = target;
		
	}

	public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
		
		SqlSession session = null;
		
		Object obj = null;
		
		try{
//			获得的session为ThreadLocal里的session，属于当前线程的
			session = SqlSessionUtil.getSqlSession();

// 			此方法就相当于受理类执行了自己的方法
//			内部逻辑不需要去理解
			obj = method.invoke(target, args);
			
			session.commit();
		}catch(Exception e){
			session.rollback();
			e.printStackTrace();
			
			//李四处理的是什么异常，继续往上抛什么异常给张三
			throw e.getCause();
		}finally{
			SqlSessionUtil.myClose(session);
		}
		
		return obj;
	}
	
	public Object getProxy(){
								//   获得受理类的类加载器和接口
		return Proxy.newProxyInstance(target.getClass().getClassLoader(), target.getClass().getInterfaces(),this);
		
	}
	
}











































