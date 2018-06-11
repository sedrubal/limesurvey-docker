-- Creation of custom databases and users.
SET @@SESSION.SQL_LOG_BIN=0;
CREATE DATABASE IF NOT EXISTS `limesurvey`;
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,INDEX,DROP,ALTER ON limesurvey.* TO limesurvey IDENTIFIED BY 'wokehf983yg0';
