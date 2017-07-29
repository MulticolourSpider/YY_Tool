# YY_Tool
Xcode 一键导入代码块 一键调用 提高开发效率 

One button import code block, a key call to improve development efficiency

使用:
```
cd YY_Tool
./setup_snippets.sh
成功之后输出:
Done  
重新新打开Xcode  (需要先完全退出Xcode)
```
查看效果图:
https://github.com/MulticolourSpider/YY_Tool/blob/master/result.png

![image](https://github.com/MulticolourSpider/YY_Tool/blob/master/result.png)

```

调   用                  实        现                触 发 方 式  
                                                   { 触发 } 表示方法内触发 可利用Xcode自动补全如:YY cr 
YY Button               一键创建UIButton              { 触发 }     
YY TableView            一键创建UITabelView           { 触发 }
YY Label                一键创建UILabel               { 触发 }
YY Window               一键创建UIWindow              { 触发 }
YY CornerRadius         一键设置圆角                   { 触发 }  
YY Dispatch_async       一键 子 -> 主 线程(GCD)        { 触发 }
YY Timer                一键 NSTimer 带暂停/开始       { 触发 }
YY ImageView            一键 UIImageView 圆角+边框     { 触发  }

YY PCH                  一键定义常用宏                 #ifndef PrefixHeader_pch
                                                    #define PrefixHeader_pch
                                                       触发 YY PCH
                                                    #endif

YY TextField            一键创建 UITextField           { 触发 }
YY ScrollView           一键创建 UIScrollView          { 触发 }
YY PageControl          一键创建 UIPageControl         { 触发 }


```



删除代码块:
```
cd YY_Tool
./clear_snippets.sh
```
清除Xcode 缓存垃圾,释放磁盘存储空间:
```
cd YY_Tool
./clear_Temp_data.sh
```
打开代码块所在位置:
```
cd YY_Tool
./open_CodeSnippets.sh
```
```
或者手动打开: Finder->前往->前往文件夹
~/Library/Developer/Xcode/UserData/CodeSnippets/
```

```
只能初始化一次 ./setup_snippets.sh 
如果想要重复初始化  
手动到:
~/Library/Developer/Xcode/UserData/CodeSnippets.backup/ 
(如果上一层没有CodeSnippets文件夹 拖动到外面 如果外面有)删除CodeSnippets.backup内的CodeSnippets文件夹 
然后./setup_snippets.sh
```
