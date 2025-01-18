/*
  Warnings:

  - You are about to drop the column `class_id` on the `times_schedules` table. All the data in the column will be lost.
  - You are about to drop the column `discipline_id` on the `times_schedules` table. All the data in the column will be lost.
  - You are about to drop the column `schedule` on the `times_schedules` table. All the data in the column will be lost.
  - You are about to drop the column `teacher_id` on the `times_schedules` table. All the data in the column will be lost.
  - You are about to drop the column `week_day` on the `times_schedules` table. All the data in the column will be lost.
  - Added the required column `description` to the `times_schedules` table without a default value. This is not possible if the table is not empty.

*/
-- CreateTable
CREATE TABLE "lessons" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "teacher_id" INTEGER NOT NULL,
    "class_id" INTEGER NOT NULL,
    "discipline_id" TEXT NOT NULL,
    "week_day" TEXT NOT NULL,
    "schedule" TEXT NOT NULL,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL,
    "deleted_at" DATETIME,
    "timeScheduleId" INTEGER,
    CONSTRAINT "lessons_teacher_id_fkey" FOREIGN KEY ("teacher_id") REFERENCES "teachers" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "lessons_class_id_fkey" FOREIGN KEY ("class_id") REFERENCES "classes" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "lessons_discipline_id_fkey" FOREIGN KEY ("discipline_id") REFERENCES "disciplines" ("discipline_id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "lessons_timeScheduleId_fkey" FOREIGN KEY ("timeScheduleId") REFERENCES "times_schedules" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_times_schedules" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "description" TEXT NOT NULL,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL,
    "deleted_at" DATETIME
);
INSERT INTO "new_times_schedules" ("created_at", "deleted_at", "id", "updated_at") SELECT "created_at", "deleted_at", "id", "updated_at" FROM "times_schedules";
DROP TABLE "times_schedules";
ALTER TABLE "new_times_schedules" RENAME TO "times_schedules";
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;
