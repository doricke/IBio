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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150205141548) do

  create_table "activities", force: true do |t|
    t.integer  "individual_id"
    t.integer  "itype_id"
    t.integer  "image_id"
    t.integer  "attachment_id"
    t.integer  "note_id"
    t.string   "activity_name", limit: 80
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "intensity"
    t.string   "qualifier",     limit: 32
  end

  create_table "activity_summaries", force: true do |t|
    t.integer  "individual_id"
    t.integer  "instrument_id"
    t.integer  "sleep_id"
    t.integer  "image_id"
    t.integer  "itype_id"
    t.string   "name"
    t.string   "qualifier"
    t.float    "amount"
    t.datetime "start_time"
    t.datetime "end_time"
    t.boolean  "is_public"
    t.float    "calories"
    t.integer  "group_id"
  end

  create_table "airs", force: true do |t|
    t.integer  "place_id"
    t.integer  "itype_id"
    t.float    "air_value"
    t.datetime "sampled_at"
    t.integer  "unit_id"
    t.integer  "note_id"
  end

  add_index "airs", ["itype_id", "place_id", "sampled_at"], name: "idx_airs_sample", using: :btree

  create_table "algorithms", force: true do |t|
    t.string   "algorithm_name", limit: 80
    t.string   "version",        limit: 40
    t.datetime "updated_at"
  end

  create_table "aligns", force: true do |t|
    t.integer  "msa_id"
    t.integer  "biosequence_id"
    t.integer  "align_rank"
    t.datetime "updated_at"
    t.string   "align_sequence", limit: 4800
  end

  create_table "allele_calls", force: true do |t|
    t.integer "locus_id"
    t.integer "experiment_id"
    t.string  "guid2",         limit: 32
    t.string  "alleles",       limit: 4
  end

  create_table "alleles", force: true do |t|
    t.integer "locus_id"
    t.integer "ethnic_id"
    t.string  "name",               limit: 40
    t.string  "seq",                limit: 1024
    t.string  "regular_expression", limit: 1024
    t.float   "allele_frequency"
  end

  create_table "ancestries", force: true do |t|
    t.integer "individual_id"
    t.integer "instrument_id"
    t.integer "itype_id"
    t.integer "ethnic_id"
    t.float   "percent"
  end

  create_table "atoms", force: true do |t|
    t.integer "structure_id"
    t.string  "chain",        limit: 4
    t.integer "aa_residue"
    t.string  "aa_name",      limit: 8
    t.integer "atom_start"
    t.integer "atom_end"
    t.string  "residue",      limit: 1
  end

  create_table "attachments", force: true do |t|
    t.integer  "individual_id"
    t.integer  "instrument_id"
    t.integer  "attachment_id"
    t.integer  "itype_id"
    t.string   "name",          limit: 120
    t.string   "content_type",  limit: 80
    t.string   "file_path",     limit: 240
    t.boolean  "is_parsed"
    t.datetime "created_at"
    t.text     "file_text",     limit: 2147483647
    t.binary   "file_binary",   limit: 2147483647
  end

  add_index "attachments", ["individual_id", "name"], name: "idx_attachments_both", using: :btree
  add_index "attachments", ["name"], name: "idx_attachments_name", using: :btree

  create_table "attributes", force: true do |t|
    t.integer  "individual_id"
    t.integer  "unit_id"
    t.string   "name",          limit: 32
    t.string   "category",      limit: 32
    t.float    "amount"
    t.datetime "measured_at"
  end

  create_table "biosequence_domains", force: true do |t|
    t.integer "biosequence_id"
    t.integer "domain_id"
    t.integer "seq_start"
    t.integer "seq_end"
  end

  add_index "biosequence_domains", ["biosequence_id", "domain_id"], name: "idx_seq_domains_both", using: :btree

  create_table "biosequences", force: true do |t|
    t.integer  "source_id"
    t.integer  "gene_id"
    t.integer  "organism_id"
    t.string   "name",          limit: 45
    t.integer  "copy_number"
    t.string   "exons",         limit: 480
    t.string   "aa_sequence",   limit: 4000
    t.text     "mrna_sequence"
    t.datetime "updated_at"
    t.string   "accession",     limit: 20
  end

  add_index "biosequences", ["organism_id", "gene_id"], name: "idx_biosequences_org_gene", using: :btree

  create_table "conservations", force: true do |t|
    t.integer "biosequence_id"
    t.integer "position"
    t.float   "level"
  end

  create_table "data_ranges", force: true do |t|
    t.integer "itype_id"
    t.string  "table_name"
    t.float   "lower"
    t.float   "upper"
    t.string  "qualifier",   limit: 40
    t.string  "description", limit: 400
  end

  create_table "data_syncs", force: true do |t|
    t.integer  "individual_id"
    t.integer  "instrument_id"
    t.integer  "algorithm_id"
    t.datetime "updated_at"
  end

  create_table "devices", force: true do |t|
    t.integer "individual_id"
    t.integer "instrument_id"
    t.string  "wear_at",       limit: 20
    t.string  "serial_no",     limit: 40
  end

  add_index "devices", ["individual_id"], name: "idx_devices_individual", using: :btree
  add_index "devices", ["serial_no"], name: "idx_devices_serial_no", using: :btree

  create_table "disease_genes", force: true do |t|
    t.integer "disease_id"
    t.integer "gene_id"
  end

  add_index "disease_genes", ["disease_id", "gene_id"], name: "idx_disease_gene_both", using: :btree

  create_table "diseases", force: true do |t|
    t.integer "note_id"
    t.string  "mim_id",  limit: 8
    t.string  "name",    limit: 240
  end

  add_index "diseases", ["mim_id"], name: "idx_diseases_mim", using: :btree

  create_table "domains", force: true do |t|
    t.integer "note_id"
    t.string  "name",    limit: 80
  end

  create_table "drinks", force: true do |t|
    t.integer  "individual_id"
    t.integer  "food_id"
    t.integer  "unit_it"
    t.float    "amount"
    t.datetime "consumed_at"
    t.float    "calories"
  end

  create_table "drug_genes", force: true do |t|
    t.integer "drug_id"
    t.integer "gene_id"
    t.string  "pharm_gkb_id", limit: 16
    t.integer "source_id"
  end

  add_index "drug_genes", ["drug_id", "gene_id"], name: "idx_drug_genes_both", using: :btree

  create_table "drug_reactions", force: true do |t|
    t.integer "drug_id"
    t.integer "pathway_id"
    t.integer "reaction_id"
    t.integer "source_id"
  end

  add_index "drug_reactions", ["drug_id", "pathway_id"], name: "idx_drug_reactions_both", using: :btree
  add_index "drug_reactions", ["pathway_id"], name: "idx_drug_reactions_pathway", using: :btree

  create_table "drugs", force: true do |t|
    t.integer "note_id"
    t.string  "name",    limit: 80
  end

  create_table "effects", force: true do |t|
    t.integer "biosequence_id"
    t.integer "variant_id"
    t.string  "name",           limit: 40
    t.string  "impact",         limit: 10
    t.string  "function_class", limit: 10
    t.string  "codon_change",   limit: 40
    t.string  "aa_change",      limit: 40
    t.string  "guid2",          limit: 32
    t.integer "residue"
  end

  create_table "epoches", force: true do |t|
    t.integer  "year"
    t.integer  "month"
    t.integer  "day"
    t.integer  "hour"
    t.integer  "minute"
    t.integer  "second"
    t.integer  "usec"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ethnics", force: true do |t|
    t.string "name",   limit: 80
    t.string "region", limit: 80
    t.string "race",   limit: 80
  end

  create_table "experiments", force: true do |t|
    t.integer  "instrument_id"
    t.integer  "itype_id"
    t.integer  "note_id"
    t.string   "name",          limit: 80
    t.datetime "created_at"
    t.integer  "individual_id"
    t.integer  "attachment_id"
  end

  create_table "families", force: true do |t|
    t.string "name",   limit: 80
    t.string "source", limit: 80
  end

  create_table "food_items", force: true do |t|
    t.integer "individual_id"
    t.integer "meal_id"
    t.integer "food_id"
    t.integer "unit_id"
    t.float   "amount"
    t.float   "calories"
  end

  create_table "foods", force: true do |t|
    t.string  "name",          limit: 80
    t.float   "calories"
    t.float   "protein"
    t.float   "fats"
    t.float   "amount"
    t.integer "unit_id"
    t.integer "itype_id"
    t.float   "cholesterol"
    t.float   "saturated_fat"
    t.float   "weight"
    t.float   "sodium"
    t.float   "sugars"
    t.float   "fiber"
  end

  create_table "gelocations", force: true do |t|
    t.integer  "individual_id"
    t.float    "logitude"
    t.float    "latitude"
    t.datetime "timepoint"
  end

  create_table "gene_reactions", force: true do |t|
    t.integer "pathway_id"
    t.integer "reaction_id"
    t.integer "gene_id"
    t.integer "role_itype_id"
  end

  create_table "genes", force: true do |t|
    t.integer  "note_id"
    t.string   "pharm_gkb_id",     limit: 16
    t.string   "name",             limit: 200
    t.string   "ncbi_gene_id",     limit: 12
    t.string   "gene_symbol",      limit: 40
    t.string   "description",      limit: 240
    t.string   "synonyms",         limit: 240
    t.string   "chromosome",       limit: 2
    t.integer  "chromosome_start"
    t.integer  "chromosome_end"
    t.boolean  "cpic_dosing"
    t.datetime "updated_at"
    t.integer  "organism_id"
  end

  add_index "genes", ["gene_symbol"], name: "idx_genes_symbol", using: :btree
  add_index "genes", ["ncbi_gene_id"], name: "idx_genes_ncbi_gene_id", using: :btree
  add_index "genes", ["organism_id", "name"], name: "idx_genes_org_name", using: :btree

  create_table "gos", force: true do |t|
    t.integer "gene_id"
    t.integer "itype_id"
    t.string  "term",     limit: 80
    t.string  "pubmed",   limit: 10
  end

  create_table "group_activities", force: true do |t|
    t.integer "group_id"
    t.integer "activity_id"
  end

  create_table "group_members", force: true do |t|
    t.integer "group_id"
    t.integer "individual_id"
    t.integer "itype_id"
  end

  create_table "groups", force: true do |t|
    t.string "name", limit: 80
  end

  create_table "ievents", force: true do |t|
    t.integer  "individual_id"
    t.integer  "activity_id"
    t.integer  "itype_id"
    t.string   "name",          limit: 80
    t.datetime "start_time"
    t.datetime "end_time"
  end

  create_table "images", force: true do |t|
    t.integer  "individual_id"
    t.integer  "activity_id"
    t.string   "name",          limit: 80
    t.string   "content_type",  limit: 80
    t.datetime "created_at"
    t.string   "image_type",    limit: 32
    t.binary   "image_blob",    limit: 16777215
  end

  create_table "individuals", force: true do |t|
    t.string  "sex",           limit: 1
    t.string  "code_name",     limit: 64
    t.string  "guid1",         limit: 32
    t.string  "guid2",         limit: 32
    t.string  "password_hash", limit: 64
    t.string  "password_salt", limit: 64
    t.string  "data_entry_id", limit: 32
    t.boolean "is_public"
    t.boolean "is_admin"
  end

  add_index "individuals", ["data_entry_id"], name: "idx_individuals_data_entry_id", using: :btree

  create_table "instruments", force: true do |t|
    t.string "name",            limit: 80
    t.string "instrument_type", limit: 40
  end

  add_index "instruments", ["name"], name: "idx_instruments_name", using: :btree

  create_table "itypes", force: true do |t|
    t.string  "name",     limit: 80
    t.string  "category", limit: 32
    t.integer "unit_id"
  end

  add_index "itypes", ["name", "category"], name: "idx_itypes_both", using: :btree

  create_table "locations", force: true do |t|
    t.integer  "individual_id"
    t.integer  "activity_id"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "altitude"
    t.integer  "bearing"
    t.float    "speed"
    t.datetime "created_at"
  end

  create_table "locus", force: true do |t|
    t.integer "disease_id"
    t.integer "gene_id"
    t.integer "itype_id"
    t.string  "name",       limit: 40
    t.string  "chromosome", limit: 2
    t.integer "position"
  end

  create_table "mats", force: true do |t|
    t.integer  "individual_id"
    t.integer  "vocal_id"
    t.integer  "attachment_id"
    t.integer  "algorithm_id"
    t.float    "score"
    t.datetime "start_time"
    t.datetime "updated_at"
  end

  create_table "meals", force: true do |t|
    t.integer  "individual_id"
    t.datetime "consumed_at"
  end

  create_table "measurements", force: true do |t|
    t.integer  "individual_id"
    t.integer  "itype_id"
    t.integer  "unit_id"
    t.integer  "normal_id"
    t.integer  "panel_id"
    t.integer  "note_id"
    t.string   "name",          limit: 80
    t.datetime "created_at"
    t.float    "result"
  end

  create_table "metaprofiles", force: true do |t|
    t.integer  "organism_id"
    t.string   "guid1",       limit: 32
    t.integer  "count"
    t.datetime "measured_at"
  end

  create_table "monitor_data", force: true do |t|
    t.integer  "instrument_id"
    t.integer  "individual_id"
    t.integer  "attachment_id"
    t.integer  "image_id"
    t.integer  "itype_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "points_per_second"
    t.integer  "points_per_hour"
    t.text     "data_vector",       limit: 2147483647
    t.integer  "device_id"
    t.integer  "epoch_id"
    t.text     "time_vector"
  end

  add_index "monitor_data", ["individual_id", "itype_id"], name: "idx_monitor_data_device", using: :btree

  create_table "msas", force: true do |t|
    t.integer  "gene_id"
    t.string   "name",        limit: 80
    t.string   "category",    limit: 40
    t.string   "description", limit: 80
    t.string   "msa_type",    limit: 4
    t.datetime "updated_at"
  end

  create_table "normals", force: true do |t|
    t.integer "itype_id"
    t.integer "ethnic_id"
    t.integer "note_id"
    t.float   "normal_low"
    t.float   "normal_high"
    t.string  "ref_range",   limit: 32
    t.string  "sex",         limit: 1
    t.integer "age_low"
    t.integer "age_high"
  end

  create_table "notes", force: true do |t|
    t.string "comment",    limit: 2048
    t.string "table_name", limit: 40
  end

  add_index "notes", ["comment"], name: "idx_notes_comment", length: {"comment"=>767}, using: :btree
  add_index "notes", ["table_name", "comment"], name: "idx_notes_both", length: {"table_name"=>nil, "comment"=>767}, using: :btree

  create_table "organisms", force: true do |t|
    t.string "name",     limit: 80
    t.string "taxonomy", limit: 480
    t.string "genus",    limit: 200
    t.string "species",  limit: 200
  end

  create_table "panels", force: true do |t|
    t.integer  "individual_id"
    t.integer  "attachment_id"
    t.integer  "itype_id"
    t.datetime "start_time"
    t.datetime "end_time"
  end

  create_table "papers", force: true do |t|
    t.string "pmid",      limit: 16
    t.string "doi",       limit: 160
    t.string "title",     limit: 480
    t.string "authors",   limit: 480
    t.string "reference", limit: 240
  end

  create_table "pathways", force: true do |t|
    t.string  "name",      limit: 160
    t.integer "source_id"
    t.string  "smpdb_id",  limit: 20
  end

  create_table "places", force: true do |t|
    t.string  "city",      limit: 80
    t.string  "state",     limit: 40
    t.float   "longitude"
    t.float   "latitude"
    t.integer "site_no"
  end

  add_index "places", ["city", "state"], name: "idx_places_city_state", using: :btree
  add_index "places", ["site_no"], name: "idx_places_site_no", using: :btree

  create_table "prescriptions", force: true do |t|
    t.integer  "drug_id"
    t.integer  "unit_it"
    t.string   "guid1",      limit: 32
    t.float    "dose"
    t.float    "daily"
    t.datetime "start_time"
    t.datetime "end_time"
  end

  create_table "reactions", force: true do |t|
    t.integer "pathway_id"
    t.integer "itype_id"
    t.integer "control_itype"
    t.string  "from",          limit: 80
    t.string  "to",            limit: 80
    t.string  "control",       limit: 80
    t.integer "rank"
  end

  create_table "relateds", force: true do |t|
    t.integer "family_id"
    t.integer "itype_id"
    t.string  "guid1a",    limit: 32
    t.string  "guild1b",   limit: 32
    t.string  "relation",  limit: 64
    t.float   "related"
  end

  create_table "sick_symptoms", force: true do |t|
    t.integer  "sick_id"
    t.integer  "symptom_id"
    t.string   "guid1",       limit: 32
    t.datetime "start_time"
    t.datetime "end_time"
    t.float    "measurement"
  end

  create_table "sicks", force: true do |t|
    t.integer  "itype_id"
    t.string   "guid1",      limit: 32
    t.datetime "start_time"
    t.datetime "end_time"
  end

  create_table "sleeps", force: true do |t|
    t.integer  "individual_id"
    t.integer  "instrument_id"
    t.integer  "image_id"
    t.integer  "note_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "light_sleep"
    t.integer  "deep_sleep"
    t.integer  "rem_sleep"
    t.integer  "secs_asleep"
    t.integer  "interruptions"
    t.string   "qualifier",     limit: 32
    t.string   "wake_up",       limit: 1
  end

  create_table "solvents", force: true do |t|
    t.integer "biosequence_id"
    t.integer "position"
    t.float   "accessibility"
  end

  create_table "sources", force: true do |t|
    t.string   "name",       limit: 80
    t.datetime "updated_at"
    t.string   "table_name", limit: 40
  end

  create_table "structure_sequences", force: true do |t|
    t.integer "structure_id"
    t.integer "biosequence_id"
    t.string  "chain",          limit: 4
    t.string  "resolution",     limit: 8
    t.integer "aa_start"
    t.integer "aa_end"
  end

  add_index "structure_sequences", ["structure_id", "biosequence_id", "chain"], name: "idx_structure_seq_triple", using: :btree

  create_table "structures", force: true do |t|
    t.string  "name",       limit: 80
    t.integer "pdb_length"
    t.text    "pdb",        limit: 2147483647
  end

  create_table "symptoms", force: true do |t|
    t.string "name", limit: 80
  end

  create_table "synonyms", force: true do |t|
    t.integer "itype_id"
    t.integer "source_id"
    t.string  "synonym_name", limit: 80
    t.string  "table_name",   limit: 40
    t.integer "record_id"
  end

  add_index "synonyms", ["table_name", "record_id", "synonym_name"], name: "idx_synonyms_triple", using: :btree

  create_table "units", force: true do |t|
    t.string "name", limit: 32
  end

  create_table "variants", force: true do |t|
    t.integer "biosequence_id"
    t.integer "disease_id"
    t.string  "guid2",          limit: 32
    t.string  "sequence_type",  limit: 4
    t.string  "mutation",       limit: 80
    t.string  "mutation_type",  limit: 8
    t.integer "sequence_start"
    t.integer "sequence_end"
    t.boolean "is_public"
    t.integer "note_id"
    t.integer "instrument_id"
    t.float   "quality"
    t.string  "dp4",            limit: 20
    t.string  "ref",            limit: 20
    t.string  "alt",            limit: 20
  end

  add_index "variants", ["biosequence_id", "instrument_id", "guid2", "sequence_start"], name: "idx_variants_find", using: :btree
  add_index "variants", ["biosequence_id", "mutation", "sequence_start"], name: "idx_variants_triple", using: :btree

  create_table "vocals", force: true do |t|
    t.integer  "individual_id"
    t.integer  "attachment_id"
    t.string   "speech_text",   limit: 2000
    t.datetime "start_time"
    t.string   "name",          limit: 120
  end

end
