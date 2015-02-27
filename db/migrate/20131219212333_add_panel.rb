class AddPanel < ActiveRecord::Migration
  def change
      AddPanel.load_data
  end  # change
    
  def self.up
    puts "AddPanel.up run"
    # AddPanel::load_data
  end  # up

  def self.load_data
    puts "#### AddPanel.load_data run"
    # Units
    mg_dl = Unit.create(:name => "mg/dl")
    mmol_l = Unit.create(:name => "mmol/l")
    u_l = Unit.create(:name => "U/L")
    g_dl = Unit.create(:name => "g/dl")
    inch = Unit.create(:name => "inches")
    lbs = Unit.create(:name => "pounds")
    bp = Unit.create(:name => "mmHg")
    count = Unit.create(:name => "count")

# Individuals

# Itypes
    metabolic_type = Itype.create(:name => "Comprehensive Metabolic Panel", :category => :panel)
    lipid_panel_type = Itype.create(:name => "Lipid Panel", :category => :panel)
    screening_panel_type = Itype.create(:name => "Screening", :category => :panel)
    checkup_panel_type = Itype.create(:name => "Checkup", :category => :panel)

    glucose = Itype.create(:name => "Gluose", :category => "metabolite")
    non_fast_glucose = Itype.create(:name => "Non-Fasting Glucose", :category => "metabolite")
    bun = Itype.create(:name => "BUN", :category => "metabolite")
    creatinine = Itype.create(:name => "Creatinine", :category => "metabolite")
    sodium = Itype.create(:name => "Sodium", :category => "metabolite")
    potassium = Itype.create(:name => "Potassium", :category => "metabolite")
    chloride = Itype.create(:name => "Chloride", :category => "metabolite")
    co2 = Itype.create(:name => "CO2", :category => "metabolite")
    alk_phos = Itype.create(:name => "ALK PHOS", :category => "metabolite")
    sgot = Itype.create(:name => "SGOT (AST)", :category => "metabolite")
    sgpt = Itype.create(:name => "SGPT (ALT)", :category => "metabolite")
    bili = Itype.create(:name => "BILI Total", :category => "metabolite")
    total_protein = Itype.create(:name => "Total Protein", :category => "metabolite")
    albumin = Itype.create(:name => "Albumin", :category => "metabolite")
    globulin = Itype.create(:name => "Globulin", :category => "metabolite")
    alb_glob = Itype.create(:name => "ALB:GLOB", :category => "metabolite")
    calcium = Itype.create(:name => "Calcium", :category => "metabolite")

    cholesterol = Itype.create(:name => "Cholesterol", :category => "lipid")
    triglyceride = Itype.create(:name => "Triglyceride", :category => "lipid")
    hdl = Itype.create(:name => "HDL", :category => "lipid")
    ldl = Itype.create(:name => "LDL calculated", :category => "lipid")
    non_hdl = Itype.create(:name => "Non-HDL calculated", :category => "lipid")

    systolic = Itype.create(:name => "Systolic Blood Pressure", :category => "measurement")
    diastolic = Itype.create(:name => "Disastolic Blood Pressure", :category => "measurement")
    pulse = Itype.create(:name => "Pulse", :category => "measurement")
    bmi = Itype.create(:name => "Body Mass Index (BMI)", :category => "measurement")
    height = Itype.create(:name => "Height", :category => "measurement")
    weight = Itype.create(:name => "Weight", :category => "measurement")
    
    Itype.create(:name => "SNP", :category => "Locus")

# Panels

# Normals
    glucose_normal = Normal.create(:itype_id => glucose.id, :normal_low => 70.0, :normal_high => 110.0, :ref_range => "70-110", :sex => "M")
    bun_normal = Normal.create(:itype_id => bun.id, :normal_low => 9.0, :normal_high => 26.0, :ref_range => "9-26", :sex => "M")
    creatinine_normal = Normal.create(:itype_id => creatinine.id, :normal_low => 0.7, :normal_high => 1.3, :ref_range => "0.7-1.3", :sex => "M")
    sodium_normal = Normal.create(:itype_id => sodium.id, :normal_low => 134.0, :normal_high => 144.0, :ref_range => "134-144", :sex => "M")
    potassium_normal = Normal.create(:itype_id => potassium.id, :normal_low => 3.2, :normal_high => 5.1, :ref_range => "3.2-5.1", :sex => "M")
    chloride_normal = Normal.create(:itype_id => chloride.id, :normal_low => 97.0, :normal_high => 109.0, :ref_range => "97-109", :sex => "M")
    co2_normal = Normal.create(:itype_id => co2.id, :normal_low => 20.0, :normal_high => 32.0, :ref_range => "20.0-32.0", :sex => "M")
    alk_phos_normal = Normal.create(:itype_id => alk_phos.id, :normal_low => 40.0, :normal_high => 150.0, :ref_range => "40-150", :sex => "M")
    sgot_normal = Normal.create(:itype_id => sgot.id, :normal_low => 15.0, :normal_high => 37.0, :ref_range => "15-37", :sex => "M")
    sgpt_normal = Normal.create(:itype_id => sgpt.id, :normal_low => 0.0, :normal_high => 55.0, :ref_range => "0-55", :sex => "M")
    bili_normal = Normal.create(:itype_id => bili.id, :normal_low => 0.2, :normal_high => 1.2, :ref_range => "0.2-1.2", :sex => "M")
    total_protein_normal = Normal.create(:itype_id => total_protein.id, :normal_low => 6.1, :normal_high => 8.2, :ref_range => "6.1-8.2", :sex => "M")
    albumin_normal = Normal.create(:itype_id => albumin.id, :normal_low => 3.4, :normal_high => 5.0, :ref_range => "3.4-5.0", :sex => "M")
    globulin_normal = Normal.create(:itype_id => globulin.id, :normal_low => 2.5, :normal_high => 4.3, :ref_range => "2.5-4.3", :sex => "M")
    alb_glob_normal = Normal.create(:itype_id => alb_glob.id, :normal_low => 0.7, :normal_high => 1.6, :ref_range => "0.7-1.6", :sex => "M")
    calcium_normal = Normal.create(:itype_id => calcium.id, :normal_low => 8.5, :normal_high => 10.5, :ref_range => "8.5-10.5", :sex => "M")
    cholesterol_normal = Normal.create(:itype_id => cholesterol.id, :normal_low => 0.0, :normal_high => 200.0, :ref_range => "<200")
    triglyceride_normal = Normal.create(:itype_id => triglyceride.id, :normal_low => 0.0, :normal_high => 150.0, :ref_range => "<150")
    hdl_normal = Normal.create(:itype_id => hdl.id, :normal_low => 40.0, :ref_range => ">40")
    ldl_normal = Normal.create(:itype_id => ldl.id, :normal_low => 0.0, :normal_high => 130.0, :ref_range => "<130")
    non_hdl_normal = Normal.create(:itype_id => non_hdl.id, :normal_low => 0.0, :normal_high => 160.0, :ref_range => "<160")

    bmi1_normal = Normal.create(:itype_id => bmi.id, :normal_low => 18.0, :normal_high => 25.0, :ref_range => "18.5-25.0", :sex => "M")
    weight1_normal = Normal.create(:itype_id => weight.id, :normal_low => 150.0, :normal_high => 195.0, :ref_range => "150-195", :sex => "M")

    systolic_normal = Normal.create(:itype_id => systolic.id, :normal_high => 120.0, :ref_range => "<120")
    diastolic_normal = Normal.create(:itype_id => diastolic.id, :normal_high => 80.0, :ref_range => "<80")
    pulse_normal = Normal.create(:itype_id => pulse.id, :normal_high => 100.0, :normal_low => 60.0, :ref_range => "60-100")

# Measurements: needs timestamps

    Itype.create(name: "Fitbit", :category => :attachment)
    Itype.create(name: "Jawbone", :category => :attachment)
    Itype.create(name: "Basis", :category => :attachment)
    # Itype.create(name: "Angel Sensor", :category => :attachment)
    Itype.create(name: "Actigraph", :category => :attachment)
    Itype.create(name: "Empatica", :category => :attachment)
    Itype.create(name: "SEM", :category => :attachment)
    Itype.create(name: "My Tracks app", :category => :attachment)
    Itype.create(name: "Moves app", :category => :attachment)
    Itype.create(name: "Sleep Cycle app", :category => :attachment)
    me23 = Itype.create(name: "23andMe", :category => :attachment)
    
    Itype.create(name: "Walking", :category => :activity)
    Itype.create(name: "Running", :category => :activity)
    Itype.create(name: "Sleeping", :category => :activity)
    Itype.create(name: "Eating", :category => :activity)
    Itype.create(name: "Skiing", :category => :activity)
    Itype.create(name: "Bicycling", :category => :activity)
    Itype.create(name: "X-country skiing", :category => :activity)
    Itype.create(name: "Jogging", :category => :activity)
    
    Itype.create(name: "skin_temp", :category => "Health Monitor")
    Itype.create(name: "heart_rate", :category => "Health Monitor")
    Itype.create(name: "air_temp", :category => "Health Monitor")
    Itype.create(name: "calories", :category => "Health Monitor")
    Itype.create(name: "gsr", :category => "Health Monitor")
    Itype.create(name: "steps", :category => "Health Monitor")
    Itype.create(name: "inactive", :category => "Health Monitor")
    Itype.create(name: "light_activity", :category => "Health Monitor")
    Itype.create(name: "moderate_activity", :category => "Health Monitor")
    Itype.create(name: "heavy_activity", :category => "Health Monitor")
    
    Itype.create(name: "Function", :category => "Gene Ontology")
    Itype.create(name: "Process", :category => "Gene Ontology")
    Itype.create(name: "Component", :category => "Gene Ontology")

    Symptom.create(name: "Fever")
    Symptom.create(name: "Runny nose")
    Symptom.create(name: "Diarrhea")
    Symptom.create(name: "Hives")
    Symptom.create(name: "Muscle aches")
    Symptom.create(name: "Stomach ache")
    Symptom.create(name: "Vomiting")
    Symptom.create(name: "Nausea")
    Symptom.create(name: "Chills")
    Symptom.create(name: "Cough")
    Symptom.create(name: "Sore throat")
    
    Instrument.create(name: "Roche 454", instrument_type: "DNA Sequencer")
    Instrument.create(name: "PacBio", instrument_type: "DNA Sequencer")
    Instrument.create(name: "Illumina", instrument_type: "DNA Sequencer")
    Instrument.create(name: "Ion Torrent PGM", instrument_type: "DNA Sequencer")
    Instrument.create(name: "Ion Torrent Proton", instrument_type: "DNA Sequencer")
    
    Instrument.create(name: "Jawbone", instrument_type: "Health Monitor")
    Instrument.create(name: "Actigraph", instrument_type: "Health Monitor")
    Instrument.create(name: "Basis watch", instrument_type: "Health Monitor")
    Instrument.create(name: "Empatica", instrument_type: "Health Monitor")
    # Instrument.create(name: "Angel Sensor", instrument_type: "Health Monitor")
    Instrument.create(name: "Fitbit", instrument_type: "Health Monitor")
    Instrument.create(name: "SEM", instrument_type: "Health Monitor")
    Instrument.create(name: "Android Phone", instrument_type: "Health Monitor")
    Instrument.create(name: "IPhone", instrument_type: "Health Monitor")
    snp_chip = Instrument.create(name: "SNP chip", instrument_type: "Health Monitor")

    british = Ethnic.create(name: "European", region: "Northern European", race: "British & Irish")
    german = Ethnic.create(name: "European", region: "Northern European", race: "French & German")
    Ethnic.create(name: "European", region: "Northern European", race: "Scandinavian")
    Ethnic.create(name: "European", region: "Northern European", race: "Finnish")
    northern = Ethnic.create(name: "European", region: "Nonspecific Northern European", race: "")
    Ethnic.create(name: "European", region: "Southern European", race: "Sardinian")
    Ethnic.create(name: "European", region: "Southern European", race: "Italian")
    Ethnic.create(name: "European", region: "Southern European", race: "Iberian")
    Ethnic.create(name: "European", region: "Southern European", race: "Balkan")
    Ethnic.create(name: "European", region: "Nonspecific Southern European", race: "")
    Ethnic.create(name: "European", region: "Eastern European", race: "")
    Ethnic.create(name: "European", region: "Ashkenazi", race: "")
    european = Ethnic.create(name: "European", region: "Nonspecific European", race: "")
    Ethnic.create(name: "Middle Eastern & North African", region: "Middle Eastern", race: "")
    Ethnic.create(name: "Middle Eastern & North African", region: "North African", race: "")
    Ethnic.create(name: "Middle Eastern & North African", region: "Nonspecific Middle Eastern & North African", race: "")
    Ethnic.create(name: "Sub-Saharan African", region: "West African", race: "")
    Ethnic.create(name: "Sub-Saharan African", region: "East African", race: "")
    Ethnic.create(name: "Sub-Saharan African", region: "Central & South African", race: "")
    Ethnic.create(name: "Sub-Saharan African", region: "Nonspecific Sub-Saharan African", race: "")
    Ethnic.create(name: "South Asian", region: "", race: "")
    Ethnic.create(name: "East Asian", region: "", race: "")
    Ethnic.create(name: "East Asian", region: "Japanese", race: "")
    Ethnic.create(name: "East Asian", region: "Korean", race: "")
    Ethnic.create(name: "East Asian", region: "Yakut", race: "")
    Ethnic.create(name: "East Asian", region: "Mongolian", race: "")
    Ethnic.create(name: "East Asian", region: "Chinese", race: "")
    Ethnic.create(name: "East Asian", region: "Southeast Asian", race: "")
    Ethnic.create(name: "East Asian", region: "Nonspecific East Asian", race: "")
    Ethnic.create(name: "Nonspecific East Asian & Native American", region: "", race: "")
    Ethnic.create(name: "Native American", region: "", race: "")
    Ethnic.create(name: "Oceanian", region: "", race: "")
    unassigned = Ethnic.create(name: "Unassigned", region: "", race: "")
    
  end  # load_data
end  # class
