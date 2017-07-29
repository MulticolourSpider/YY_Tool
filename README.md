# YY_Tool
Xcode自定义代码块 提高开发效率

#使用方法:
cd YY_Tool
./setup_snippets.sh
成功之后输出 Done  

重新新打开Xcode  (需要先完全退出Xcode)

#调   用                  实        现                触 发 方 式  
                                                    #( {}表示方法内 可利用Xcode自动补全如:YY cr )
YY Button               一键创建UIButton              { 触发 }     
YY TableView            一键创建UITabelView           { 触发 }
YY Label                一键创建UILabel               { 触发 }
YY Window               一键创建UIWindow              { 触发 }
YY CornerRadius         一键设置圆角                   { 触发 }  
YY Dispatch_async       一键 子 -> 主 线程(GCD)        { 触发 }
YY Timer                一键 NSTimer 带暂停/开始       { 触发 }











#删除代码块
cd YY_Tool
./clear_snippets.sh

#清除Xcode 缓存垃圾,释放磁盘存储空间
cd YY_Tool
./clear_Temp_data.sh

#打开代码块所在位置
cd YY_Tool
./open_CodeSnippets.sh
或者手动打开: Finder->前往->前往文件夹
~/Library/Developer/Xcode/UserData/CodeSnippets/



#只能初始化一次 ./setup_snippets.sh 
#如果想要重复初始化  
#手动到:
#~/Library/Developer/Xcode/UserData/CodeSnippets.backup/ 
#(如果上一层没有CodeSnippets文件夹 拖动到外面 如果外面有)删除CodeSnippets.backup内的CodeSnippets文件夹 
#然后./setup_snippets.sh

