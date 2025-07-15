## PowerDNS Auht Helm

本项目是PowerDNS Auth应用的helm应用。请注意以下文档和细节

要求如下：
1. 支持通过job按照values.yaml中设置的数据库类型：MySQL、PostgreSQL、SQLite3设置好的用户名和密码检查和初始化数据库，如果已经存在这些表了则跳过
2. 继续在这个job中支持将powerdns的配置通过环境变量传递到配置文件pdns.conf中，配置文件为config类型，环境变量应该为全大写且开头为`PDNS_`，并且使用`_`连接，例如`allow-axfr-ips`将使用`PDNS_ALLOW_AXFR_IPS`来传递
3. 参照文件夹`deprecated`的一些处理，但是这是一个helm，请直接使用官方镜像`powerdns/pdns-auth-49`，并且允许自定义镜像版本和镜像地址
4. 请注意安全检测
5. 请参照成熟的helm应用设置好一些k8s的服务、Service Account、Secret、Services、Endpoints等等一切必须的切安全的规则

### 参考文档
- [PowerDNS Auth官方镜像](https://hub.docker.com/r/powerdns/pdns-auth-49)
- [PostgreSQL初始化SQL](https://github.com/PowerDNS/pdns/blob/master/modules/gpgsqlbackend/schema.pgsql.sql)
- [MySQL初始化SQL](https://github.com/PowerDNS/pdns/blob/master/modules/gmysqlbackend/schema.mysql.sql)
- [SQLite3初始化SQL](https://github.com/PowerDNS/pdns/blob/master/modules/gsqlite3backend/schema.sqlite3.sql)
- [PowerDNS Auth官方镜像文档](https://github.com/PowerDNS/pdns/blob/master/Docker-README.md)
- [PowerDNS Auth设置](https://doc.powerdns.com/authoritative/settings.html)