-- CreateTable
CREATE TABLE "teachers" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL,
    "deleted_at" DATETIME
);

-- CreateTable
CREATE TABLE "classes_teachers" (
    "class_id" INTEGER NOT NULL,
    "teacher_id" INTEGER NOT NULL,
    CONSTRAINT "classes_teachers_class_id_fkey" FOREIGN KEY ("class_id") REFERENCES "classes" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "classes_teachers_teacher_id_fkey" FOREIGN KEY ("teacher_id") REFERENCES "teachers" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "disciplines_teachers" (
    "discipline_id" INTEGER NOT NULL,
    "teacher_id" INTEGER NOT NULL,
    CONSTRAINT "disciplines_teachers_discipline_id_fkey" FOREIGN KEY ("discipline_id") REFERENCES "disciplines" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "disciplines_teachers_teacher_id_fkey" FOREIGN KEY ("teacher_id") REFERENCES "teachers" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateIndex
CREATE UNIQUE INDEX "classes_teachers_class_id_teacher_id_key" ON "classes_teachers"("class_id", "teacher_id");

-- CreateIndex
CREATE UNIQUE INDEX "disciplines_teachers_discipline_id_teacher_id_key" ON "disciplines_teachers"("discipline_id", "teacher_id");
