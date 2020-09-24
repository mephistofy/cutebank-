require 'roo'
require 'roo-xls'
require 'write_xlsx'

def test
    xls = Roo::Excel.new('/home/mangos/Загрузки/IITiYTC_20_21_1s_6.xls')

    created_xlsx = WriteXLSX.new('/home/mangos/Загрузки/createXLSX.xlsx')
    xls.each_with_pagename do |name, sheet|
        worksheet = created_xlsx.add_worksheet
        i = 0
        while i < sheet.last_row do
            j=0
            while j < sheet.last_column do
                worksheet.write(i,j, sheet.cell(i,j))
                j+=1
            end
            i +=1
        end
    end
    created_xlsx.close
end

def parser(path, output_files_path, number)
    xlsx = Roo::Excelx.new(path, {:expand_merged_ranges => true})
    regularExp = %r{\w{2,5}\-{1}\d+}
    regularError = %r{}
    hash_groups = Hash.new
    stringWithGroups = Array.new
    xlsx.each_with_pagename do |name, sheet|
        i = 0
        while i < sheet.last_row do 
            #puts sheet.row(
            if sheet.row(i).to_s.match(regularExp)  
                j = 0
                #puts sheet.row(i)
                #puts sheet.last_column
                while j < sheet.last_column do
                    if sheet.cell(i,j).to_s.match(regularExp)
                        if !sheet.cell(i,j).to_s.include? "РАСПИСАНИЕ"  
                            hash_groups.store(sheet.cell(i,j), j)
                        end
                        #puts "[cell] #{sheet.cell(i,j)}"
                    end
                    j+=1
                end
                break 
            end
            #puts sheet.row(i)
            i+=1
        end
        while i <sheet.last_row do
            j = 0
            while j < sheet.last_column do
                if hash_groups.has_value?(j) 
                    a = "#{sheet.cell(i,j)}"
                    if  a.strip != ''
                         
                        #iterator to the right
                        j2 = j+1
                        lesson_type = ''
                        room = ''
                        while j2 < sheet.last_column do 
                            if (("#{sheet.cell(i,j2)}" == 'Л') | ("#{sheet.cell(i,j2)}" == 'ПЗ') | ("#{sheet.cell(i,j2)}" == 'ЛЗ'))
                                
                                lesson_type = "#{sheet.cell(i,j2)}"
                                if (("#{sheet.cell(i,j2+1)}" != 'понедельник') & ("#{sheet.cell(i,j2+1)}" != 'вторник') & ("#{sheet.cell(i,j2+1)}" != 'среда') & ("#{sheet.cell(i,j2+1)}" != 'четверг') & ("#{sheet.cell(i,j2+1)}" != 'пятница') & ("#{sheet.cell(i,j2+1)}" != 'суббота'))
                                    room = "#{sheet.cell(i,j2+1)}"
                                end
                            end
                            j2+=1
                        end
                        #iterator to the left
                        j3 = j-1
                        week = ''
                        time = ''
                        lesson_number = ''
                        day = ''
                        while j3 > sheet.first_column do 
                            if (("#{sheet.cell(i,j3)}" == 'нечет.') | ("#{sheet.cell(i,j3)}" == 'четн.'))
                                week = "#{sheet.cell(i,j3)}"
                                time = "#{sheet.cell(i,j3-1)}"
                                lesson_number = "#{sheet.cell(i,j3-2)}"
                                day = "#{sheet.cell(i,j3-3)}"
                            end
                            j3-=1 
                        end
                        if ((day != '') & (lesson_number != '')  & (time != '')  & (week !=''))
                            a = "#{sheet.cell(i,j).to_s}"
                            
                            a.gsub!('<b>', '')
                            a.gsub!('</b>', '')
                            File.write(output_files_path +'result'+ number.to_s+'.txt', " #{hash_groups.key(j)} #{day} #{lesson_number} #{time} #{week} #{a} #{lesson_type} #{room} \n", mode: 'a') 
                            #puts " #{hash_groups.key(j)} #{day} #{lesson_number} #{time} #{week} #{sheet.cell(i,j).inspect} #{lesson_type} #{room} "
                        end
                    end
                end
                j+=1
            end 
            #puts "[string] #{sheet.row(i)}"
            i+=1
        end
        hash_groups.clear
    end
end
#puts hash_groups.inspect
 #puts xls.sheets[0].ce11(1,1)
#xls.to_csv

parser('/home/mangos/Загрузки/fdf.xlsx', '/home/mangos/projects/excelParser/', 1)

File.write('df.txt', [1,2,3])