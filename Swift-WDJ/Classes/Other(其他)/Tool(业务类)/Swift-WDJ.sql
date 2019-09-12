-- 创建数据表
CREATE TABLE IF NOT EXISTS "T_Topic" (
"id" INTEGER NOT NULL,
"topic" TEXT NOT NULL,
"topicType" INTEGER NOT NULL,
"createTime" TEXT NOT NULL DEFAULT (datetime('now', 'localtime')),
PRIMARY KEY("id")
);
