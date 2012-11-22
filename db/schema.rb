# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121120140818) do

  create_table "attachments", :force => true do |t|
    t.integer  "challenge_id"
    t.string   "file"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "name"
  end

  create_table "challenges", :force => true do |t|
    t.string   "name",       :null => false
    t.text     "text",       :null => false
    t.string   "solution",   :null => false
    t.integer  "author_id"
    t.integer  "points",     :null => false
    t.string   "category",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "participants", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "points"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "provider"
    t.string   "uid"
  end

  create_table "solutions", :force => true do |t|
    t.integer  "challenge_id"
    t.integer  "participant_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.text     "writeup",        :default => "", :null => false
  end

end
