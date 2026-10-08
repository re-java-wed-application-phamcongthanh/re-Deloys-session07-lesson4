#!/bin/bash
# ==============================================================================
# Script: setup_nginx_proxy.sh
# Mo ta: Tu dong cau hinh Reverse Proxy Nginx cho Spring Boot App
# Khoa hoc: DevOps Fundamentals - Session 07 - Bai 4
# ==============================================================================

set -e

echo "=== [1/6] Kiem tra quyen root ==="
if [ "$EUID" -ne 0 ]; then
  echo "Loi: Vui long chay script duoi quyen root hoac dung sudo!"
  exit 1
fi

echo "=== [2/6] Khoi tao thu muc web va copy trang tinh index.html ==="
mkdir -p /var/www/html
cp index.html /var/www/html/index.html
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

echo "=== [3/6] Copy file cau hinh Nginx sites-available ==="
cp spring-proxy.conf /etc/nginx/sites-available/spring-proxy.conf

echo "=== [4/6] Tao Symlink sang sites-enabled va go bo default site ==="
# Go bo default symlink neu co
rm -f /etc/nginx/sites-enabled/default
ln -sf /etc/nginx/sites-available/spring-proxy.conf /etc/nginx/sites-enabled/spring-proxy.conf

echo "=== [5/6] Kiem tra cu phap Nginx (nginx -t) ==="
nginx -t

echo "=== [6/6] Reload Nginx Service ==="
systemctl reload nginx

echo "================================================="
echo "Kiem tra ket noi bang curl:"
echo "--- 1. Static Page (/) ---"
curl -I http://localhost/
echo ""
echo "--- 2. Backend Proxy API (/api/) ---"
curl -I http://localhost/api/health || echo "(Luu y: Can dam bao Spring Boot app dang chay o port 8082)"
echo "================================================="
echo "CAU HINH REVERSE PROXY NGINX HOAN THANH THANH CONG!"
echo "================================================="
