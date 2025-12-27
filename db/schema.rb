# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_12_01_000003) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "conversations", force: :cascade do |t|
    t.bigint "sender_id", null: false
    t.bigint "receiver_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["receiver_id"], name: "index_conversations_on_receiver_id"
    t.index ["sender_id", "receiver_id"], name: "index_conversations_on_sender_id_and_receiver_id", unique: true
    t.index ["sender_id"], name: "index_conversations_on_sender_id"
  end

  create_table "jwt_denylists", force: :cascade do |t|
    t.string "jti"
    t.datetime "exp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_jwt_denylists_on_jti"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "conversation_id", null: false
    t.bigint "sender_id", null: false
    t.bigint "receiver_id", null: false
    t.text "body", null: false
    t.boolean "read", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["receiver_id"], name: "index_messages_on_receiver_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "plans", force: :cascade do |t|
    t.string "name", null: false
    t.string "stripe_price_id"
    t.string "apple_product_id"
    t.string "google_product_id"
    t.decimal "amount", precision: 10, scale: 2
    t.string "currency", default: "usd"
    t.string "interval", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["apple_product_id"], name: "index_plans_on_apple_product_id", unique: true
    t.index ["google_product_id"], name: "index_plans_on_google_product_id", unique: true
    t.index ["stripe_price_id"], name: "index_plans_on_stripe_price_id", unique: true
  end

  create_table "subscription_events", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "subscription_id", null: false
    t.integer "event_type", null: false
    t.string "processor_event_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["processor_event_id"], name: "index_subscription_events_on_processor_event_id", unique: true
    t.index ["subscription_id"], name: "index_subscription_events_on_subscription_id"
    t.index ["user_id"], name: "index_subscription_events_on_user_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "plan_id", null: false
    t.integer "processor", null: false
    t.string "processor_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "current_period_start"
    t.datetime "current_period_end"
    t.decimal "amount", precision: 10, scale: 2
    t.string "currency", default: "usd"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id"], name: "index_subscriptions_on_plan_id"
    t.index ["processor_id"], name: "index_subscriptions_on_processor_id", unique: true
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_interactions", force: :cascade do |t|
    t.integer "user_id"
    t.boolean "liked"
    t.bigint "verse_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "verse_id"], name: "index_user_interactions_on_user_and_verse", unique: true
    t.index ["verse_id"], name: "index_user_interactions_on_verse_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "stripe_customer_id"
    t.string "processor"
    t.string "password_digeset"
    t.string "jti"
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "verse_tags", force: :cascade do |t|
    t.bigint "verse_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_verse_tags_on_tag_id"
    t.index ["verse_id"], name: "index_verse_tags_on_verse_id"
  end

  create_table "verses", force: :cascade do |t|
    t.integer "book", null: false
    t.integer "chapter", null: false
    t.boolean "favorite", default: false, null: false
    t.integer "verse", null: false
    t.string "text", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "source"
  end

  add_foreign_key "conversations", "users", column: "receiver_id"
  add_foreign_key "conversations", "users", column: "sender_id"
  add_foreign_key "messages", "conversations"
  add_foreign_key "messages", "users", column: "receiver_id"
  add_foreign_key "messages", "users", column: "sender_id"
  add_foreign_key "subscription_events", "subscriptions"
  add_foreign_key "subscription_events", "users"
  add_foreign_key "subscriptions", "plans"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "user_interactions", "users"
  add_foreign_key "verse_tags", "tags"
  add_foreign_key "verse_tags", "verses"
end
