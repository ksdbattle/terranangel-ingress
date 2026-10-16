FROM nginx:1.27-alpine

# Render 会在运行时注入 $PORT（默认 10000），nginx 必须监听这个端口，写死 80 会导致
# 健康检查失败、部署无限重启。
# 官方镜像的 entrypoint 会把 /etc/nginx/templates/*.template 用 envsubst 渲染后
# 输出到 /etc/nginx/conf.d/*.conf。
#
# NGINX_ENVSUBST_FILTER 这一行必须保留：它限定 envsubst「只替换 $PORT」。
# 否则 $host、$proxy_add_x_forwarded_for、$connection_upgrade 这些 nginx 内置变量
# 会被一起当成环境变量替换成空串，配置直接坏掉。
ENV NGINX_ENVSUBST_FILTER=PORT

COPY default.conf.template /etc/nginx/templates/default.conf.template
