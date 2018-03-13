# 数据保护机制测试案例
测试sqlite数据库在开启数据保护情况下，会报出异常disk IO error，然后db会损坏。
通过设置sqlite flag避免此类情况发生

