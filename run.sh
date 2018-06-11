#!/usr/bin/env sh

#
# Create required databases, secure installation and start mysql_safe
#

set -e
set -o pipefail

echo ""
echo "[i] Initialize DB"
echo ""
mysql_install_db --user=mysql > /dev/null

echo ""
echo "[i] Start MariaDB in background to run initialization"
echo ""
mysqld_safe --user=mysql --skip-networking &
sleep 5  # wait to come up

echo ""
echo "[i] Do what mysql_secure_installation would do, init database, set passwords."
echo ""

mysql < /init_safe_install.sql
mysql < /init_users.sql

echo ""
echo "[i] Stop MariaDB"
echo ""
mysqladmin shutdown

echo ""
echo "[i] Start mariadb in background"
echo ""
mysqld_safe --user=mysql &

echo ""
echo "[i] Start php-fpm in background"
echo ""
php-fpm -F &

echo ""
echo "[i] Start nginx in foreground"
echo ""
exec nginx -g "daemon off;"
