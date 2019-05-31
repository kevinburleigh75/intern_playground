# frozen_string_literal: true

require 'json-schema'
require 'json_schemer'
require 'rj_schema'
require 'json'
require 'benchmark'

schema = JSON.parse(File.read('intern_playground/JSON Schema Verifier Benchmark/TestFiles/test-schema.json'))
bigschema = JSON.parse(File.read('intern_playground/JSON Schema Verifier Benchmark/TestFiles/BigLearnTestSchema.json'))
bigschemaref = JSON.parse(File.read('intern_playground/JSON Schema Verifier Benchmark/TestFiles/BiglearnTestSchemaRefs.json'))
schemer = JSONSchemer.schema(schema)
bigschemer = JSONSchemer.schema(bigschema)
refschemer = JSONSchemer.schema(bigschemaref)
N = 100

# Official
File.open('json-schema-benchmark-comparison-official', 'w') do |line|
  Dir.glob('intern_playground/JSON Schema Verifier Benchmark/TestFiles/draft4/*.json') do |json_test|
    next if (json_test == '.') || (json_test == '..')

    line.puts "_____" + json_test.match('intern_playground/JSON Schema Verifier Benchmark/TestFiles/draft4/(.*)')[1] + "_____"
    test = JSON.parse(File.read(json_test))
    line.puts("json-schema")
      bool1 = true
      bool2 = true
      bool3 = true

      bench1 = Benchmark.realtime do (
      N.times do
        bool1 = JSON::Validator.validate(schema,test) ? true : false
      end
      )
    end



    bench2 = Benchmark.realtime do (
      N.times do
        bool2 = schemer.valid?(test) ? true : false
      end
      )
    end



    bench3 = Benchmark.realtime do (
      N.times do
        bool3 = RjSchema::Validator.new.valid?(schema,File.new(json_test)) ? true : false
      end
    )
    end


      line.puts("json-schema:                 " + bench1.to_s + " " + bool1.to_s +
                    "\njson_schemer:                " + bench2.to_s + " " + bool2.to_s +
                    "\nRj_schema:                   " + bench3.to_s + " " + bool3.to_s +
                    "\njson_schemer vs json-schema: " + (bench1/bench2).to_s + "x speedup" +
                    "\nrj_schema vs json-schema:    " + (bench1/bench3).to_s + "x speedup"
      )
  end
end
# No refs
File.open('json-schema-benchmark-comparison-biglearn', 'w') do |line|
  Dir.glob('intern_playground/JSON Schema Verifier Benchmark/TestFiles/draft4/BiglearnTests/*.json') do |json_test|
    next if (json_test == '.') || (json_test == '..')

    line.puts "_____" + json_test.match('intern_playground/JSON Schema Verifier Benchmark/TestFiles/draft4/BiglearnTests/(.*)')[1] + "_____"
    bigtest = JSON.parse(File.read(json_test))

    valid1 = true
    valid2 = true
    valid3 = true

    json_schema_time = Benchmark.realtime do (
        valid1 = JSON::Validator.validate(bigschema,bigtest) ? true : false
    )
    end
   json_schemer_time = Benchmark.realtime do (
      valid2 = bigschemer.valid?(bigtest) ? true : false
   )
    end

    rj_schema_time = Benchmark.realtime do (
      valid3 = RjSchema::Validator.new.valid?(bigschema,File.new(json_test)) ? true : false
      )
    end

    line.puts("json-schema:                 " + json_schema_time.to_s + " " + valid1.to_s +
              "\njson_schemer:                " + json_schemer_time.to_s + " " + valid2.to_s +
              "\nRj_schema:                   " + rj_schema_time.to_s + " " + valid3.to_s +
              "\njson_schemer vs json-schema: " + (json_schema_time/json_schemer_time).to_s + "x speedup" +
              "\nrj_schema vs json-schema:    " + (json_schema_time/rj_schema_time).to_s + "x speedup"
               )
  end
end
# refs
File.open('json-schema-benchmark-comparison-biglearn-refs', 'w') do |line|
  Dir.glob('intern_playground/JSON Schema Verifier Benchmark/TestFiles/draft4/BiglearnTests/*.json') do |json_test|
    next if (json_test == '.') || (json_test == '..')

    line.puts "_____" + json_test.match('intern_playground/JSON Schema Verifier Benchmark/TestFiles/draft4/BiglearnTests/(.*)')[1] + "_____"
    bigtest = JSON.parse(File.read(json_test))

    valid1 = true
    valid2 = true
    valid3 = true

    json_schema_time = Benchmark.realtime do (
    valid1 = JSON::Validator.validate(bigschemaref,bigtest) ? true : false
    )
    end
    json_schemer_time = Benchmark.realtime do (
    valid2 = refschemer.valid?(bigtest) ? true : false
    )
    end

    rj_schema_time = Benchmark.realtime do (
    valid3 = RjSchema::Validator.new.valid?(bigschemaref,File.new(json_test)) ? true : false
    )
    end

    line.puts("json-schema:                 " + json_schema_time.to_s + " " + valid1.to_s +
                  "\njson_schemer:                " + json_schemer_time.to_s + " " + valid2.to_s +
                  "\nRj_schema:                   " + rj_schema_time.to_s + " " + valid3.to_s +
                  "\njson_schemer vs json-schema: " + (json_schema_time/json_schemer_time).to_s + "x speedup" +
                  "\nrj_schema vs json-schema:    " + (json_schema_time/rj_schema_time).to_s + "x speedup"
    )
  end
end