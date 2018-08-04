CREATE TABLE `group` (
	`id` INT AUTO_INCREMENT,
	`name` VARCHAR(20) NOT NULL,
	`description` TEXT NOT NULL,
	UNIQUE (`name`),
	PRIMARY KEY (`id`)
) CHARACTER SET utf8 COLLATE utf8_unicode_ci;

CREATE TABLE `user` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(30) NOT NULL DEFAULT '',
	`mail` VARCHAR(32) NOT NULL DEFAULT '',
	`group` INT NOT NULL,
	`blanklisted` TINYINT(1) NOT NULL DEFAULT 0,
	`status` TINYINT(1) NOT NULL DEFAULT 1,
	`reg_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`lastlogin_time` TIMESTAMP DEFAULT NULL,
	UNIQUE (`name`),
	PRIMARY KEY (`id`),
	FOREIGN KEY (`group`) REFERENCES group(`id`)
) CHARACTER SET utf8 COLLATE utf8_unicode_ci;

CREATE TABLE `category` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(20) NOT NULL,
	`description` TEXT NOT NULL DEFAULT '',
	PRIMARY KEY (`id`)
) CHARACTER SET utf8 COLLATE utf8_unicode_ci;

CREATE TABLE `video` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`title` TEXT NOT NULL DEFAULT 'No Title',
	`upload_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`status` TINYINT(1) NOT NULL,
	`description` TEXT NOT NULL DEFAULT '',
	`duration` TIME NOT NULL,
	`owner` INT NOT NULL,
	`play_times` INT NOT NULL DEFAULT 0,
	`category` INT NOT NULL,
	`tags` TEXT NOT NULL DEFAULT '',
	PRIMARY KEY (`id`),
	FOREIGN KEY (`owner`) REFERENCES user(`id`),
	FOREIGN KEY (`category`) REFERENCES category(`id`)
) CHARACTER SET utf8 COLLATE utf8_unicode_ci;

CREATE TABLE `danmaku` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`video` INT NOT NULL,
	`owner` INT NOT NULL,
	`text` TEXT NOT NULL,
	`position` TINYINT(1) NOT NULL DEFAULT 0,
	`offset` TIME NOT NULL,
	`created_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`)
	FOREIGN KEY (`video`) REFERENCES video(`id`),
	FOREIGN KEY (`owner`) REFERENCES user(`id`)
) CHARACTER SET utf8 COLLATE utf8_unicode_ci;

CREATE TABLE `comment` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`video` INT NOT NULL,
	`owner` INT NOT NULL,
	`content` TEXT NOT NULL,
	`reply_to` INT DEFAULT NULL,
	`created_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`modified_time` TIMESTAMP DEFAULT NULL,
	PRIMARY KEY (`id`),
	FOREIGN KEY (`video`) REFERENCES video(`id`),
	FOREIGN KEY (`owner`) REFERENCES user(`id`)
) CHARACTER SET utf8 COLLATE utf8_unicode_ci;

CREATE TABLE `message` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`from` INT NOT NULL,
	`to` INT NOT NULL,
	`title` TEXT NOT NULL,
	`content` TEXT,
	`sent_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`read_time` TIMESTAMP DEFAULT NULL,
	PRIMARY KEY (`id`),
	FOREIGN KEY (`from`) REFERENCES user(`id`),
	FOREIGN KEY (`to`) REFERENCES user(`id`)
) CHARACTER SET utf8 COLLATE utf8_unicode_ci;