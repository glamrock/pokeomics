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

ActiveRecord::Schema.define(:version => 20100929155909) do

  create_table "abilities", :force => true do |t|
    t.string  "name",          :limit => 24,   :null => false
    t.integer "generation_id",                 :null => false
    t.string  "effect",        :limit => 5120, :null => false
    t.string  "short_effect",                  :null => false
  end

  add_index "abilities", ["generation_id"], :name => "generation_id"

  create_table "ability_flavor_text", :id => false, :force => true do |t|
    t.integer "ability_id",                     :null => false
    t.integer "version_group_id",               :null => false
    t.string  "flavor_text",      :limit => 64, :null => false
  end

  add_index "ability_flavor_text", ["version_group_id"], :name => "version_group_id"

  create_table "ability_names", :id => false, :force => true do |t|
    t.integer "ability_id",                :null => false
    t.integer "language_id",               :null => false
    t.string  "name",        :limit => 16, :null => false
  end

  add_index "ability_names", ["language_id"], :name => "language_id"

  create_table "berries", :force => true do |t|
    t.integer "item_id",              :null => false
    t.integer "firmness_id",          :null => false
    t.integer "natural_gift_power"
    t.integer "natural_gift_type_id"
    t.integer "size",                 :null => false
    t.integer "max_harvest",          :null => false
    t.integer "growth_time",          :null => false
    t.integer "soil_dryness",         :null => false
    t.integer "smoothness",           :null => false
  end

  add_index "berries", ["firmness_id"], :name => "firmness_id"
  add_index "berries", ["item_id"], :name => "item_id"
  add_index "berries", ["natural_gift_type_id"], :name => "natural_gift_type_id"

  create_table "berry_firmness", :force => true do |t|
    t.string "name", :limit => 10, :null => false
  end

  create_table "berry_flavors", :id => false, :force => true do |t|
    t.integer "berry_id",        :null => false
    t.integer "contest_type_id", :null => false
    t.integer "flavor",          :null => false
  end

  add_index "berry_flavors", ["contest_type_id"], :name => "contest_type_id"

  create_table "contest_combos", :id => false, :force => true do |t|
    t.integer "first_move_id",  :null => false
    t.integer "second_move_id", :null => false
  end

  add_index "contest_combos", ["second_move_id"], :name => "second_move_id"

  create_table "contest_effects", :force => true do |t|
    t.integer "appeal",      :limit => 2,  :null => false
    t.integer "jam",         :limit => 2,  :null => false
    t.string  "flavor_text", :limit => 64, :null => false
    t.string  "effect",                    :null => false
  end

  create_table "contest_types", :force => true do |t|
    t.string "name",   :limit => 6, :null => false
    t.string "flavor", :limit => 6, :null => false
    t.string "color",  :limit => 6, :null => false
  end

  create_table "egg_groups", :force => true do |t|
    t.string "name", :limit => 16, :null => false
  end

  create_table "encounter_condition_value_map", :id => false, :force => true do |t|
    t.integer "encounter_id",                 :null => false
    t.integer "encounter_condition_value_id", :null => false
  end

  add_index "encounter_condition_value_map", ["encounter_condition_value_id"], :name => "encounter_condition_value_id"

  create_table "encounter_condition_values", :force => true do |t|
    t.integer "encounter_condition_id",               :null => false
    t.string  "name",                   :limit => 64, :null => false
    t.boolean "is_default",                           :null => false
  end

  add_index "encounter_condition_values", ["encounter_condition_id"], :name => "encounter_condition_id"

  create_table "encounter_conditions", :force => true do |t|
    t.string "name", :limit => 64, :null => false
  end

  create_table "encounter_slot_conditions", :id => false, :force => true do |t|
    t.integer "encounter_slot_id",      :null => false
    t.integer "encounter_condition_id", :null => false
  end

  add_index "encounter_slot_conditions", ["encounter_condition_id"], :name => "encounter_condition_id"

  create_table "encounter_slots", :force => true do |t|
    t.integer "version_group_id",     :null => false
    t.integer "encounter_terrain_id", :null => false
    t.integer "slot"
    t.integer "rarity",               :null => false
  end

  add_index "encounter_slots", ["encounter_terrain_id"], :name => "encounter_terrain_id"
  add_index "encounter_slots", ["version_group_id"], :name => "version_group_id"

  create_table "encounter_terrain", :force => true do |t|
    t.string "name", :limit => 64, :null => false
  end

  create_table "encounters", :force => true do |t|
    t.integer "version_id",        :null => false
    t.integer "location_area_id",  :null => false
    t.integer "encounter_slot_id", :null => false
    t.integer "pokemon_id",        :null => false
    t.integer "min_level",         :null => false
    t.integer "max_level",         :null => false
  end

  add_index "encounters", ["encounter_slot_id"], :name => "encounter_slot_id"
  add_index "encounters", ["location_area_id"], :name => "location_area_id"
  add_index "encounters", ["pokemon_id"], :name => "pokemon_id"
  add_index "encounters", ["version_id"], :name => "version_id"

  create_table "evolution_chains", :force => true do |t|
    t.integer "growth_rate_id",       :null => false
    t.integer "baby_trigger_item_id"
  end

  add_index "evolution_chains", ["baby_trigger_item_id"], :name => "baby_trigger_item_id"
  add_index "evolution_chains", ["growth_rate_id"], :name => "growth_rate_id"

  create_table "evolution_triggers", :force => true do |t|
    t.string "identifier", :limit => 16, :null => false
  end

  create_table "experience", :id => false, :force => true do |t|
    t.integer "growth_rate_id", :null => false
    t.integer "level",          :null => false
    t.integer "experience",     :null => false
  end

  create_table "generations", :force => true do |t|
    t.integer "main_region_id"
    t.integer "canonical_pokedex_id"
    t.string  "name",                 :limit => 16, :null => false
  end

  add_index "generations", ["canonical_pokedex_id"], :name => "canonical_pokedex_id"
  add_index "generations", ["main_region_id"], :name => "main_region_id"

  create_table "growth_rates", :force => true do |t|
    t.string "name",    :limit => 20,  :null => false
    t.string "formula", :limit => 500, :null => false
  end

  create_table "item_categories", :force => true do |t|
    t.integer "pocket_id",               :null => false
    t.string  "name",      :limit => 16, :null => false
  end

  add_index "item_categories", ["pocket_id"], :name => "pocket_id"

  create_table "item_flag_map", :id => false, :force => true do |t|
    t.integer "item_id",      :null => false
    t.integer "item_flag_id", :null => false
  end

  add_index "item_flag_map", ["item_flag_id"], :name => "item_flag_id"

  create_table "item_flags", :force => true do |t|
    t.string "identifier", :limit => 24, :null => false
    t.string "name",       :limit => 64, :null => false
  end

  create_table "item_flavor_text", :id => false, :force => true do |t|
    t.integer "item_id",          :null => false
    t.integer "version_group_id", :null => false
    t.string  "flavor_text",      :null => false
  end

  add_index "item_flavor_text", ["version_group_id"], :name => "version_group_id"

  create_table "item_fling_effects", :force => true do |t|
    t.string "effect", :null => false
  end

  create_table "item_internal_ids", :id => false, :force => true do |t|
    t.integer "item_id",       :null => false
    t.integer "generation_id", :null => false
    t.integer "internal_id",   :null => false
  end

  add_index "item_internal_ids", ["generation_id"], :name => "generation_id"

  create_table "item_names", :id => false, :force => true do |t|
    t.integer "item_id",                   :null => false
    t.integer "language_id",               :null => false
    t.string  "name",        :limit => 16, :null => false
  end

  add_index "item_names", ["language_id"], :name => "language_id"

  create_table "item_pockets", :force => true do |t|
    t.string "identifier", :limit => 16, :null => false
    t.string "name",       :limit => 16, :null => false
  end

  create_table "items", :force => true do |t|
    t.string  "name",            :limit => 20,   :null => false
    t.integer "category_id",                     :null => false
    t.integer "cost",                            :null => false
    t.integer "fling_power"
    t.integer "fling_effect_id"
    t.string  "effect",          :limit => 5120, :null => false
  end

  add_index "items", ["category_id"], :name => "category_id"
  add_index "items", ["fling_effect_id"], :name => "fling_effect_id"

  create_table "languages", :force => true do |t|
    t.string "iso639",  :limit => 2,  :null => false
    t.string "iso3166", :limit => 2,  :null => false
    t.string "name",    :limit => 16, :null => false
  end

  create_table "location_area_encounter_rates", :id => false, :force => true do |t|
    t.integer "location_area_id",     :null => false
    t.integer "encounter_terrain_id", :null => false
    t.integer "version_id",           :null => false
    t.integer "rate"
  end

  add_index "location_area_encounter_rates", ["encounter_terrain_id"], :name => "encounter_terrain_id"
  add_index "location_area_encounter_rates", ["version_id"], :name => "version_id"

  create_table "location_areas", :force => true do |t|
    t.integer "location_id",               :null => false
    t.integer "internal_id",               :null => false
    t.string  "name",        :limit => 64
  end

  add_index "location_areas", ["location_id"], :name => "location_id"

  create_table "location_internal_ids", :id => false, :force => true do |t|
    t.integer "location_id",   :null => false
    t.integer "generation_id", :null => false
    t.integer "internal_id",   :null => false
  end

  add_index "location_internal_ids", ["generation_id"], :name => "generation_id"

  create_table "locations", :force => true do |t|
    t.integer "region_id"
    t.string  "name",      :limit => 64, :null => false
  end

  add_index "locations", ["region_id"], :name => "region_id"

  create_table "machines", :id => false, :force => true do |t|
    t.integer "machine_number",   :null => false
    t.integer "version_group_id", :null => false
    t.integer "item_id",          :null => false
    t.integer "move_id",          :null => false
  end

  add_index "machines", ["item_id"], :name => "item_id"
  add_index "machines", ["move_id"], :name => "move_id"
  add_index "machines", ["version_group_id"], :name => "version_group_id"

  create_table "move_battle_styles", :force => true do |t|
    t.string "name", :limit => 8, :null => false
  end

  create_table "move_damage_classes", :force => true do |t|
    t.string "name",        :limit => 8,  :null => false
    t.string "description", :limit => 64, :null => false
  end

  create_table "move_effect_categories", :force => true do |t|
    t.string  "name",            :limit => 64, :null => false
    t.boolean "can_affect_user",               :null => false
  end

  create_table "move_effect_category_map", :id => false, :force => true do |t|
    t.integer "move_effect_id",          :null => false
    t.integer "move_effect_category_id", :null => false
    t.boolean "affects_user",            :null => false
  end

  add_index "move_effect_category_map", ["move_effect_category_id"], :name => "move_effect_category_id"

  create_table "move_effects", :force => true do |t|
    t.integer "priority",     :limit => 2,    :null => false
    t.string  "short_effect", :limit => 256,  :null => false
    t.string  "effect",       :limit => 5120, :null => false
  end

  create_table "move_flag_types", :force => true do |t|
    t.string "identifier",  :limit => 16,  :null => false
    t.string "name",        :limit => 32,  :null => false
    t.string "description", :limit => 128, :null => false
  end

  create_table "move_flags", :id => false, :force => true do |t|
    t.integer "move_id",           :null => false
    t.integer "move_flag_type_id", :null => false
  end

  add_index "move_flags", ["move_flag_type_id"], :name => "move_flag_type_id"

  create_table "move_flavor_text", :id => false, :force => true do |t|
    t.integer "move_id",          :null => false
    t.integer "version_group_id", :null => false
    t.string  "flavor_text",      :null => false
  end

  add_index "move_flavor_text", ["version_group_id"], :name => "version_group_id"

  create_table "move_names", :id => false, :force => true do |t|
    t.integer "move_id",                   :null => false
    t.integer "language_id",               :null => false
    t.string  "name",        :limit => 16, :null => false
  end

  add_index "move_names", ["language_id"], :name => "language_id"

  create_table "move_targets", :force => true do |t|
    t.string "name",        :limit => 32,  :null => false
    t.string "description", :limit => 128, :null => false
  end

  create_table "moves", :force => true do |t|
    t.string  "name",                    :limit => 24, :null => false
    t.integer "generation_id",                         :null => false
    t.integer "type_id",                               :null => false
    t.integer "power",                   :limit => 2,  :null => false
    t.integer "pp",                      :limit => 2,  :null => false
    t.integer "accuracy",                :limit => 2
    t.integer "target_id",                             :null => false
    t.integer "damage_class_id",                       :null => false
    t.integer "effect_id",                             :null => false
    t.integer "effect_chance"
    t.integer "contest_type_id"
    t.integer "contest_effect_id"
    t.integer "super_contest_effect_id"
  end

  add_index "moves", ["contest_effect_id"], :name => "contest_effect_id"
  add_index "moves", ["contest_type_id"], :name => "contest_type_id"
  add_index "moves", ["damage_class_id"], :name => "damage_class_id"
  add_index "moves", ["effect_id"], :name => "effect_id"
  add_index "moves", ["generation_id"], :name => "generation_id"
  add_index "moves", ["super_contest_effect_id"], :name => "super_contest_effect_id"
  add_index "moves", ["target_id"], :name => "target_id"
  add_index "moves", ["type_id"], :name => "type_id"

  create_table "nature_battle_style_preferences", :id => false, :force => true do |t|
    t.integer "nature_id",            :null => false
    t.integer "move_battle_style_id", :null => false
    t.integer "low_hp_preference",    :null => false
    t.integer "high_hp_preference",   :null => false
  end

  add_index "nature_battle_style_preferences", ["move_battle_style_id"], :name => "move_battle_style_id"

  create_table "nature_names", :id => false, :force => true do |t|
    t.integer "nature_id",                :null => false
    t.integer "language_id",              :null => false
    t.string  "name",        :limit => 8, :null => false
  end

  add_index "nature_names", ["language_id"], :name => "language_id"

  create_table "nature_pokeathlon_stats", :id => false, :force => true do |t|
    t.integer "nature_id",          :null => false
    t.integer "pokeathlon_stat_id", :null => false
    t.integer "max_change",         :null => false
  end

  add_index "nature_pokeathlon_stats", ["pokeathlon_stat_id"], :name => "pokeathlon_stat_id"

  create_table "natures", :force => true do |t|
    t.string  "name",              :limit => 8, :null => false
    t.integer "decreased_stat_id",              :null => false
    t.integer "increased_stat_id",              :null => false
    t.integer "hates_flavor_id",                :null => false
    t.integer "likes_flavor_id",                :null => false
  end

  add_index "natures", ["decreased_stat_id"], :name => "decreased_stat_id"
  add_index "natures", ["hates_flavor_id"], :name => "hates_flavor_id"
  add_index "natures", ["increased_stat_id"], :name => "increased_stat_id"
  add_index "natures", ["likes_flavor_id"], :name => "likes_flavor_id"

  create_table "pokeathlon_stats", :force => true do |t|
    t.string "name", :limit => 8, :null => false
  end

  create_table "pokedex_version_groups", :id => false, :force => true do |t|
    t.integer "pokedex_id",       :null => false
    t.integer "version_group_id", :null => false
  end

  add_index "pokedex_version_groups", ["version_group_id"], :name => "version_group_id"

  create_table "pokedexes", :force => true do |t|
    t.integer "region_id"
    t.string  "name",        :limit => 16,  :null => false
    t.string  "description", :limit => 512
  end

  add_index "pokedexes", ["region_id"], :name => "region_id"

  create_table "pokemon", :force => true do |t|
    t.string  "name",                     :limit => 20, :null => false
    t.string  "forme_name",               :limit => 16
    t.integer "forme_base_pokemon_id"
    t.integer "generation_id"
    t.integer "evolution_chain_id"
    t.integer "height",                                 :null => false
    t.integer "weight",                                 :null => false
    t.string  "species",                  :limit => 16, :null => false
    t.integer "color_id",                               :null => false
    t.integer "pokemon_shape_id"
    t.integer "habitat_id"
    t.integer "gender_rate",                            :null => false
    t.integer "capture_rate",                           :null => false
    t.integer "base_experience",                        :null => false
    t.integer "base_happiness",                         :null => false
    t.boolean "is_baby",                                :null => false
    t.integer "hatch_counter",                          :null => false
    t.boolean "has_gen4_fem_sprite",                    :null => false
    t.boolean "has_gen4_fem_back_sprite",               :null => false
  end

  add_index "pokemon", ["color_id"], :name => "color_id"
  add_index "pokemon", ["evolution_chain_id"], :name => "evolution_chain_id"
  add_index "pokemon", ["forme_base_pokemon_id"], :name => "forme_base_pokemon_id"
  add_index "pokemon", ["generation_id"], :name => "generation_id"
  add_index "pokemon", ["habitat_id"], :name => "habitat_id"
  add_index "pokemon", ["pokemon_shape_id"], :name => "pokemon_shape_id"

  create_table "pokemon_abilities", :id => false, :force => true do |t|
    t.integer "pokemon_id", :null => false
    t.integer "ability_id", :null => false
    t.integer "slot",       :null => false
  end

  add_index "pokemon_abilities", ["ability_id"], :name => "ability_id"

  create_table "pokemon_colors", :force => true do |t|
    t.string "name", :limit => 6, :null => false
  end

  create_table "pokemon_dex_numbers", :id => false, :force => true do |t|
    t.integer "pokemon_id",     :null => false
    t.integer "pokedex_id",     :null => false
    t.integer "pokedex_number", :null => false
  end

  add_index "pokemon_dex_numbers", ["pokedex_id"], :name => "pokedex_id"

  create_table "pokemon_egg_groups", :id => false, :force => true do |t|
    t.integer "pokemon_id",   :null => false
    t.integer "egg_group_id", :null => false
  end

  add_index "pokemon_egg_groups", ["egg_group_id"], :name => "egg_group_id"

  create_table "pokemon_evolution", :primary_key => "to_pokemon_id", :force => true do |t|
    t.integer "from_pokemon_id",                      :null => false
    t.integer "evolution_trigger_id",                 :null => false
    t.integer "trigger_item_id"
    t.integer "minimum_level"
    t.string  "gender",                  :limit => 0
    t.integer "location_id"
    t.integer "held_item_id"
    t.string  "time_of_day",             :limit => 0
    t.integer "known_move_id"
    t.integer "minimum_happiness"
    t.integer "minimum_beauty"
    t.integer "relative_physical_stats"
    t.integer "party_pokemon_id"
  end

  add_index "pokemon_evolution", ["evolution_trigger_id"], :name => "evolution_trigger_id"
  add_index "pokemon_evolution", ["from_pokemon_id"], :name => "from_pokemon_id"
  add_index "pokemon_evolution", ["held_item_id"], :name => "held_item_id"
  add_index "pokemon_evolution", ["known_move_id"], :name => "known_move_id"
  add_index "pokemon_evolution", ["location_id"], :name => "location_id"
  add_index "pokemon_evolution", ["party_pokemon_id"], :name => "party_pokemon_id"
  add_index "pokemon_evolution", ["trigger_item_id"], :name => "trigger_item_id"

  create_table "pokemon_flavor_text", :id => false, :force => true do |t|
    t.integer "pokemon_id",  :null => false
    t.integer "version_id",  :null => false
    t.string  "flavor_text", :null => false
  end

  add_index "pokemon_flavor_text", ["version_id"], :name => "version_id"

  create_table "pokemon_form_groups", :primary_key => "pokemon_id", :force => true do |t|
    t.boolean "is_battle_only",                 :null => false
    t.string  "description",    :limit => 1024, :null => false
  end

  create_table "pokemon_form_sprites", :id => false, :force => true do |t|
    t.integer "id",                                           :null => false
    t.integer "pokemon_id",                                   :null => false
    t.integer "introduced_in_version_group_id",               :null => false
    t.string  "name",                           :limit => 16
    t.boolean "is_default"
  end

  add_index "pokemon_form_sprites", ["introduced_in_version_group_id"], :name => "introduced_in_version_group_id"
  add_index "pokemon_form_sprites", ["pokemon_id"], :name => "pokemon_id"

  create_table "pokemon_habitats", :force => true do |t|
    t.string "name", :limit => 16, :null => false
  end

  create_table "pokemon_individuals", :force => true do |t|
    t.integer  "species_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pokemon_internal_ids", :id => false, :force => true do |t|
    t.integer "pokemon_id",    :null => false
    t.integer "generation_id", :null => false
    t.integer "internal_id",   :null => false
  end

  add_index "pokemon_internal_ids", ["generation_id"], :name => "generation_id"

  create_table "pokemon_items", :id => false, :force => true do |t|
    t.integer "pokemon_id", :null => false
    t.integer "version_id", :null => false
    t.integer "item_id",    :null => false
    t.integer "rarity",     :null => false
  end

  add_index "pokemon_items", ["item_id"], :name => "item_id"
  add_index "pokemon_items", ["version_id"], :name => "version_id"

  create_table "pokemon_move_methods", :force => true do |t|
    t.string "name",        :limit => 64, :null => false
    t.string "description",               :null => false
  end

  create_table "pokemon_moves", :id => false, :force => true do |t|
    t.integer "pokemon_id",             :null => false
    t.integer "version_group_id",       :null => false
    t.integer "move_id",                :null => false
    t.integer "pokemon_move_method_id", :null => false
    t.integer "level",                  :null => false
    t.integer "order"
  end

  add_index "pokemon_moves", ["level"], :name => "idx_autoinc_level"
  add_index "pokemon_moves", ["level"], :name => "ix_pokemon_moves_level"
  add_index "pokemon_moves", ["move_id"], :name => "ix_pokemon_moves_move_id"
  add_index "pokemon_moves", ["pokemon_id"], :name => "ix_pokemon_moves_pokemon_id"
  add_index "pokemon_moves", ["pokemon_move_method_id"], :name => "ix_pokemon_moves_pokemon_move_method_id"
  add_index "pokemon_moves", ["version_group_id"], :name => "ix_pokemon_moves_version_group_id"

  create_table "pokemon_names", :id => false, :force => true do |t|
    t.integer "pokemon_id",                :null => false
    t.integer "language_id",               :null => false
    t.string  "name",        :limit => 16, :null => false
  end

  add_index "pokemon_names", ["language_id"], :name => "language_id"

  create_table "pokemon_shapes", :force => true do |t|
    t.string "name",         :limit => 24, :null => false
    t.string "awesome_name", :limit => 16, :null => false
  end

  create_table "pokemon_stats", :id => false, :force => true do |t|
    t.integer "pokemon_id", :null => false
    t.integer "stat_id",    :null => false
    t.integer "base_stat",  :null => false
    t.integer "effort",     :null => false
  end

  add_index "pokemon_stats", ["stat_id"], :name => "stat_id"

  create_table "pokemon_types", :id => false, :force => true do |t|
    t.integer "pokemon_id", :null => false
    t.integer "type_id",    :null => false
    t.integer "slot",       :null => false
  end

  add_index "pokemon_types", ["type_id"], :name => "type_id"

  create_table "regions", :force => true do |t|
    t.string "name", :limit => 16, :null => false
  end

  create_table "species", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stats", :force => true do |t|
    t.integer "damage_class_id"
    t.string  "name",            :limit => 16, :null => false
  end

  add_index "stats", ["damage_class_id"], :name => "damage_class_id"

  create_table "super_contest_combos", :id => false, :force => true do |t|
    t.integer "first_move_id",  :null => false
    t.integer "second_move_id", :null => false
  end

  add_index "super_contest_combos", ["second_move_id"], :name => "second_move_id"

  create_table "super_contest_effects", :force => true do |t|
    t.integer "appeal",      :limit => 2,  :null => false
    t.string  "flavor_text", :limit => 64, :null => false
  end

  create_table "type_efficacy", :id => false, :force => true do |t|
    t.integer "damage_type_id", :null => false
    t.integer "target_type_id", :null => false
    t.integer "damage_factor",  :null => false
  end

  add_index "type_efficacy", ["target_type_id"], :name => "target_type_id"

  create_table "type_names", :id => false, :force => true do |t|
    t.integer "type_id",                   :null => false
    t.integer "language_id",               :null => false
    t.string  "name",        :limit => 16, :null => false
  end

  add_index "type_names", ["language_id"], :name => "language_id"

  create_table "types", :force => true do |t|
    t.string  "name",            :limit => 8, :null => false
    t.string  "abbreviation",    :limit => 3, :null => false
    t.integer "generation_id",                :null => false
    t.integer "damage_class_id",              :null => false
  end

  add_index "types", ["damage_class_id"], :name => "damage_class_id"
  add_index "types", ["generation_id"], :name => "generation_id"

  create_table "version_group_regions", :id => false, :force => true do |t|
    t.integer "version_group_id", :null => false
    t.integer "region_id",        :null => false
  end

  add_index "version_group_regions", ["region_id"], :name => "region_id"

  create_table "version_groups", :force => true do |t|
    t.integer "generation_id", :null => false
  end

  add_index "version_groups", ["generation_id"], :name => "generation_id"

  create_table "versions", :force => true do |t|
    t.integer "version_group_id",               :null => false
    t.string  "name",             :limit => 32, :null => false
  end

  add_index "versions", ["version_group_id"], :name => "version_group_id"

end
