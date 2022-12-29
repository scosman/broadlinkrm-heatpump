require 'csv'
require 'json'

def options_from_csv csv
    options = []
    csvHeader = csv.first
    csv.each_with_index do |item, i| 
        next if i == 0

        option = {}
        csvHeader.each_with_index do |header, ii|
            option[header] = item[ii]

            if header == "Temp"
                option[header] = item[ii].to_i
            end
        end
        options << option
    end

    return options
end

fujitsuCodesCsv = CSV.read("./heatpumps/Fujitsu-Halcyon-codes.csv")
mitsubishiCodesCsv = CSV.read("./heatpumps/Mitsubishi-codes.csv")
mitsubishiOptions = options_from_csv mitsubishiCodesCsv
fujitsuOptions = options_from_csv fujitsuCodesCsv

broadlinkAccessories = []

heatpumps = [
    {
        'name': 'kitchen heatpump',
        'options': fujitsuOptions,
        'macAddr': '11:11:11:11:11:11' # PUT REAL MAC ADDRESS HERE
    },
    {
        'name': 'Office Heatpump',
        'options': fujitsuOptions,
        'macAddr': '11:11:11:11:11:11' # PUT REAL MAC ADDRESS HERE
    },
    {
        'name': 'Bedroom Heatpump',
        'options': fujitsuOptions,
        'macAddr': '11:11:11:11:11:11' # PUT REAL MAC ADDRESS HERE
    },
    {
        'name': 'Lower Stairs Heatpump',
        'options': mitsubishiOptions,
        'macAddr': '11:11:11:11:11:11' # PUT REAL MAC ADDRESS HERE
    },
    {
        'name': 'Upper Stairs Heatpump',
        'options': mitsubishiOptions,
        'macAddr': '11:11:11:11:11:11' # PUT REAL MAC ADDRESS HERE
    }
]

def dataBlockForMode mode, options 
    dataBlock = {}
    offHexCode = options.select{|o| o["Mode"] == "Off"}.first["Code"]
    dataBlock['off'] = offHexCode
    # on is required, but seems to work when blank, see 'turnOnWhenOff'
    dataBlock['on'] = '' 

    temperatureCodes = {}
    filteredOptions = options.select{|o| o["Mode"] == mode}
    filteredOptions.each do |option|
        temperatureCodes[option['Temp'].to_s] = option['Code']
    end
    dataBlock['temperatureCodes'] = temperatureCodes

    return dataBlock
end

heatpumps.each do |heatpump|
    options = heatpump[:options]
    minCoolTemp = options.select{|o| o["Mode"] == "Cool"}.map{|o| o["Temp"]}.min
    maxCoolTemp = options.select{|o| o["Mode"] == "Cool"}.map{|o| o["Temp"]}.max
    minHeatTemp = options.select{|o| o["Mode"] == "Heat"}.map{|o| o["Temp"]}.min
    maxHeatTemp = options.select{|o| o["Mode"] == "Heat"}.map{|o| o["Temp"]}.max
    puts "#{heatpump[:name]}: Heat #{minHeatTemp}-#{maxHeatTemp}, Cool #{minCoolTemp}-#{maxCoolTemp}"

    accessory = {}
    accessory['name'] = heatpump[:name]
    accessory['type'] = 'heater-cooler'
    accessory['temperatureUnits'] = 'C'
    # if we don't set, HK exposes half degrees in UI, and those won't work since they aren't in csv
    accessory['tempStepSize'] = 1
    accessory['turnOnWhenOff'] = false
    accessory['defaultNowTemperature'] = 20 # fake temp to report
    accessory['noHistory'] = true
    accessory['noHumidity'] = true
    accessory['temperatureUpdateFrequency'] = 180
    # in reality, heater allows lower min temp than cooler, and can't set min/max per mode
    # TODO P2 -- being restrictive here. Prevents me from setting heat=10c when on vacation.
    # benefit is all modes work at all supported temperatures in UI, so keeping that for now
    accessory['minTemperature'] = [minHeatTemp, minCoolTemp].max
    accessory['maxTemperature'] = [maxHeatTemp, maxCoolTemp].min
    # TODO -- figure these out, getting error 30 > 25 (our max), even when setting to 25
    accessory['coolingThresholdTemperature'] = maxCoolTemp
    accessory['heatingThresholdTemperature'] = minHeatTemp
    accessory['host'] = heatpump[:macAddr]

    accessory['data'] = {
        'heat': dataBlockForMode('Heat', options),
        'cool': dataBlockForMode('Cool', options)
    }

    broadlinkAccessories << accessory
end

stringToInjectToTemplate = ''
if broadlinkAccessories.length > 0
   broadlinkAccessories.each do |accessory|
        stringToInjectToTemplate << ",\n" 
        stringToInjectToTemplate << JSON.pretty_generate(accessory)
   end
end

puts 'paste this in your Homebridge config:'
puts stringToInjectToTemplate 

