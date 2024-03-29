CREATE TABLE `user` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `hashed_password` char(97) NOT NULL,
  `fullname` varchar(30) NOT NULL,
  `cellphone` char(10) NOT NULL,
  `email` varchar(255),
  `date_joined` date NOT NULL DEFAULT (CURDATE()),
  `date_quitted` date DEFAULT NULL
);

CREATE TABLE `owner` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `fullname` varchar(30) NOT NULL,
  `cellphone` char(10) NOT NULL,
  `email` varchar(255),
  `address` varchar(255)
);

CREATE TABLE `pet` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `owner_id` int NOT NULL,
  `breed_id` int NOT NULL,
  `code` char(10) UNIQUE NOT NULL,
  `name` varchar(50) NOT NULL,
  `sex` tinyint,
  `is_neutered` tinyint DEFAULT 0,
  `birthday` DATE DEFAULT NULL,
  `chip` bigint unsigned DEFAULT NULL,
  `comment` varchar(256),
  `status` tinyint NOT NULL DEFAULT 1,
  `status_comment` varchar(60) DEFAULT NULL
);

CREATE TABLE `breed` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `species` char(1) NOT NULL,
  `breed` varchar(30) NOT NULL
);

CREATE TABLE `cage` (
  `name` char(3) PRIMARY KEY NOT NULL,
  `inpatient_id` int UNIQUE
);

CREATE TABLE `exam` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(50) UNIQUE NOT NULL,
  `statement` varchar(255),
  `price` mediumint unsigned NOT NULL DEFAULT 0
);

CREATE TABLE `treatment` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(50) UNIQUE NOT NULL,
  `statement` varchar(255),
  `price` mediumint unsigned NOT NULL DEFAULT 0
);

CREATE TABLE `medicine` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(50) UNIQUE NOT NULL,
  `type` varchar(20) NOT NULL,
  `dose` smallint unsigned,
  `dose_unit` varchar(30),
  `statement` varchar(50),
  `price` mediumint unsigned NOT NULL
);

CREATE TABLE `register` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `vet_id` int NOT NULL,
  `pet_id` int NOT NULL,
  `reserve_time` datetime NOT NULL DEFAULT (current_timestamp()),
  `subjective` varchar(512) NOT NULL
);

CREATE TABLE `record` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `code` char(10) UNIQUE NOT NULL,
  `vet_id` int NOT NULL,
  `pet_id` int NOT NULL,
  `created_at` datetime NOT NULL DEFAULT (current_timestamp()),
  `updated_at` datetime NOT NULL DEFAULT (current_timestamp()),
  `subjective` varchar(512) NOT NULL,
  `objective` varchar(512) NOT NULL,
  `assessment` varchar(512) NOT NULL,
  `plan` varchar(512) NOT NULL,
  `is_archive` tinyint NOT NULL DEFAULT 0,
  `total` mediumint unsigned NOT NULL DEFAULT 0,
  `is_paid` tinyint NOT NULL DEFAULT 0
);

CREATE TABLE `record_exam` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `record_id` int NOT NULL,
  `exam_id` int NOT NULL,
  `file_path` varchar(100) NOT NULL,
  `quantity` tinyint NOT NULL DEFAULT 1,
  `discount` float NOT NULL DEFAULT 1,
  `subtotal` mediumint unsigned NOT NULL DEFAULT 0,
  `comment` varchar(100)
);

CREATE TABLE `record_medication` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `record_id` int NOT NULL,
  `name` varchar(30) NOT NULL,
  `type` varchar(30) NOT NULL,
  `comment` varchar(100)
);

CREATE TABLE `medication_detail` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `record_medication_id` int NOT NULL,
  `medicine_id` int NOT NULL,
  `dose` int NOT NULL DEFAULT 0,
  `frequency` varchar(20) NOT NULL,
  `day` tinyint NOT NULL DEFAULT 1,
  `quantity` smallint unsigned NOT NULL DEFAULT 1,
  `discount` float NOT NULL DEFAULT 1,
  `subtotal` mediumint unsigned NOT NULL DEFAULT 0
);

CREATE TABLE `record_treatment` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `record_id` int NOT NULL,
  `treatment_id` int NOT NULL,
  `quantity` tinyint NOT NULL DEFAULT 1,
  `discount` float NOT NULL DEFAULT 1,
  `subtotal` mediumint unsigned NOT NULL DEFAULT 0,
  `comment` varchar(100)
);

CREATE TABLE `inpatient` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `code` char(10) UNIQUE NOT NULL,
  `vet_id` int NOT NULL,
  `pet_id` int NOT NULL,
  `charge_start` date NOT NULL DEFAULT (CURDATE()),
  `charge_end` date DEFAULT NULL,
  `cage` char(3) NOT NULL,
  `summary` varchar(100)
);

CREATE TABLE `inpatient_order` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `code` char(10) UNIQUE NOT NULL,
  `inpatient_id` int NOT NULL,
  `date` date NOT NULL DEFAULT (CURDATE()),
  `created_at` datetime DEFAULT (CURRENT_TIMESTAMP),
  `updated_at` datetime DEFAULT (CURRENT_TIMESTAMP),
  `is_paid` tinyint NOT NULL DEFAULT 0,
  `total` mediumint unsigned NOT NULL DEFAULT 0,
  `comment` varchar(100)
);

CREATE TABLE `inpatient_order_detail` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `inpatient_order_id` int NOT NULL,
  `priority` tinyint NOT NULL DEFAULT 0,
  `content` varchar(100) NOT NULL,
  `frequency` varchar(20),
  `schedule` varchar(100),
  `price` mediumint unsigned NOT NULL DEFAULT 0,
  `times` tinyint NOT NULL DEFAULT 0,
  `subtotal` mediumint unsigned NOT NULL DEFAULT 0,
  `comment` varchar(100)
);

CREATE INDEX `user_index_0` ON `user` (`fullname`);

CREATE INDEX `pet_index_1` ON `pet` (`code`);

CREATE INDEX `exam_index_2` ON `exam` (`name`);

CREATE INDEX `treatment_index_3` ON `treatment` (`name`);

CREATE INDEX `medicine_index_4` ON `medicine` (`name`);

CREATE INDEX `record_index_5` ON `record` (`code`);

CREATE INDEX `inpatient_index_6` ON `inpatient` (`code`);

CREATE INDEX `inpatient_order_index_7` ON `inpatient_order` (`code`);

ALTER TABLE `pet` ADD FOREIGN KEY (`breed_id`) REFERENCES `breed` (`id`);

ALTER TABLE `pet` ADD FOREIGN KEY (`owner_id`) REFERENCES `owner` (`id`);

ALTER TABLE `register` ADD FOREIGN KEY (`pet_id`) REFERENCES `pet` (`id`);

ALTER TABLE `register` ADD FOREIGN KEY (`vet_id`) REFERENCES `user` (`id`);

ALTER TABLE `record` ADD FOREIGN KEY (`vet_id`) REFERENCES `user` (`id`);

ALTER TABLE `record` ADD FOREIGN KEY (`pet_id`) REFERENCES `pet` (`id`);

ALTER TABLE `record_exam` ADD FOREIGN KEY (`record_id`) REFERENCES `record` (`id`) ON DELETE CASCADE;

ALTER TABLE `record_exam` ADD FOREIGN KEY (`exam_id`) REFERENCES `exam` (`id`);

ALTER TABLE `record_medication` ADD FOREIGN KEY (`record_id`) REFERENCES `record` (`id`) ON DELETE CASCADE;

ALTER TABLE `medication_detail` ADD FOREIGN KEY (`record_medication_id`) REFERENCES `record_medication` (`id`) ON DELETE CASCADE;

ALTER TABLE `medication_detail` ADD FOREIGN KEY (`medicine_id`) REFERENCES `medicine` (`id`);

ALTER TABLE `record_treatment` ADD FOREIGN KEY (`record_id`) REFERENCES `record` (`id`) ON DELETE CASCADE;

ALTER TABLE `record_treatment` ADD FOREIGN KEY (`treatment_id`) REFERENCES `treatment` (`id`);

ALTER TABLE `inpatient` ADD FOREIGN KEY (`pet_id`) REFERENCES `pet` (`id`);

ALTER TABLE `inpatient` ADD FOREIGN KEY (`vet_id`) REFERENCES `user` (`id`);

ALTER TABLE `inpatient_order` ADD FOREIGN KEY (`inpatient_id`) REFERENCES `inpatient` (`id`);

ALTER TABLE `inpatient_order_detail` ADD FOREIGN KEY (`inpatient_order_id`) REFERENCES `inpatient_order` (`id`) ON DELETE CASCADE;
