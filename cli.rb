## CLI Project

require 'date'
require 'terminal-table'
require 'colorize'
require 'colorized_string'
require 'csv'
require 'pry'

BORROWER_RECORDS = 'borrower_records.csv'
LIBRARY_ITEMS = 'library_items.csv'

## Borrower
# - name
# - contact_number
# - email

class Borrower
  attr_accessor :name, :contact_number, :email

  def initialize(hash)
    @name = hash[:name]
    @contact_number = hash[:contact_number]
    @email = hash[:email]
  end

  BORROWER_HEADERS = ['name', 'contact_number', 'email']

  def to_csv_row
    [@name, @contact_number, @email]
  end

  def Borrower.from_csv_row(row)
    name = row['name']
    contact_number = row['contact_number']
    email = row['email']
    return Borrower.new(name: name, contact_number: contact_number, email: email)
  end
end

## LibraryItem
# - name
# - item title
# - item type
# - date borrowed
# - due date

class LibraryItem
  attr_accessor :name, :item_title, :item_type, :date_borrowed, :due_date

  def initialize(hash)
    @name = hash[:name]
    @item_title = hash[:item_title]
    @item_type = hash[:item_type]
    @date_borrowed = hash[:date_borrowed]
    @due_date = hash[:due_date]
  end

  ITEM_HEADERS = ['name', 'item_title', 'item_type', 'date_borrowed', 'due_date']

  def to_csv_row
    [@name, @item_title, @item_type, @date_borrowed, @due_date]
  end

  def LibraryItem.from_csv_row(row)
    name = row['name']
    item_title = row['item_title']
    item_type = row['item_type']
    date_borrowed = row['date_borrowed']
    due_date = row['due_date']
    return LibraryItem.new(name: name, item_title: item_title, item_type: item_type, date_borrowed: date_borrowed, due_date: due_date)
  end
end

## Display main menu in a table

quit_app = false
while quit_app != true do
  system "clear"
  table = Terminal::Table.new title: 'LIBRARY ITEMS MANAGEMENT SYSTEM', headings: ['Options', 'Functions'], style: {:border_x => "=", :border_i => "*"} do |t|
    t.add_row ['   1', 'Insert New Borrower Details']
    t.add_row ['   2', 'Display All Borrowers Information']
    t.add_row ['   3', 'Add Borrowed Item/s']
    t.add_row ['   4', 'Display All Borrowed Items']
    t.add_row ['   5', 'Show Fines For All Overdue Items']
    t.add_row ['   0', 'Exit Application']
  end

  puts
  puts table.to_s
  puts
  print "Please select an option: "
  select = $stdin.gets.chomp

  case select
  when "1"
    quit_option1 = false
    insert_again = "y"
      while quit_option1 != true do
        if insert_again == "y"
          system "clear"
          puts
          print "Name: "
          name = $stdin.gets.chomp
          print "Contact Number: "
          contact_number = $stdin.gets.chomp
          print "Email Address: "
          email = $stdin.gets.chomp

    ## Update borrower records file

          CSV.open(BORROWER_RECORDS, 'a+') do |csv|
          # If csv file is empty, create header
            if File.zero?(BORROWER_RECORDS)
              csv << Borrower::BORROWER_HEADERS
            end
            borrower = Borrower.new(
              name: name,
              contact_number: contact_number,
              email: email,
            )
            row = borrower.to_csv_row
            csv << row
          end
        end
        system "clear"
        puts
        print "Insert Another Borrower Details? (Y/N): "
        insert_again = $stdin.gets.chomp.downcase
        quit_option1 = true if insert_again == "n"
      end

  when "2"
    quit_option2 = false
    while quit_option2 != true do
      system "clear"
      borrower_details_hash = {}
      table = Terminal::Table.new title: 'BORROWERS INFORMATION LIST', headings: ['Name', 'Contact Number', 'Email Address'], style: {:border_x => "=", :border_i => "*"} do |t|
        CSV.foreach(BORROWER_RECORDS, headers: true) do |row|
          borrower = Borrower.from_csv_row(row)
          borrower_details_hash = borrower.instance_variables.each_with_object({}) { |var, hash| hash[var.to_s.delete("@")] = borrower.instance_variable_get(var) }
          print_name = " "
          print_contact_number = " "
          print_email = " "
            borrower_details_hash.each do |key, value|
              print_name = value if key == "name"
              print_contact_number = value if key == "contact_number"
              print_email = value if key == "email"
            end
          t.add_row [print_name, print_contact_number, print_email]
        end
      end
      puts
      puts table.to_s
      puts
      print "Go Back To Main Menu? (Y/N): "
      back_to_main = $stdin.gets.chomp.downcase
      quit_option2 = true if back_to_main == "y"
    end

  when "3"
    quit_option3 = false
    insert_again = "y"
      while quit_option3 != true do
        if insert_again == "y"
          system "clear"
          puts
          print "Borrower's Name: "
          name = $stdin.gets.chomp
          print "Item Title: "
          item_title = $stdin.gets.chomp
          print "Item Type (B=books, M=magazines, C=CDs, D=DVDs): "
          item_type = $stdin.gets.chomp
          print "Date Borrowed (ddmmyyyy): "
          date_borrowed = $stdin.gets.chomp
          print "Due Date (ddmmyyyy): "
          due_date = $stdin.gets.chomp

          ## Update library item records file

          CSV.open(LIBRARY_ITEMS, 'a+') do |csv|
            # If csv file is empty, create header
            if File.zero?(LIBRARY_ITEMS)
              csv << LibraryItem::ITEM_HEADERS
            end
            library_item = LibraryItem.new(
              name: name,
              item_title: item_title,
              item_type: item_type,
              date_borrowed: date_borrowed,
              due_date: due_date,
            )
            row = library_item.to_csv_row
            csv << row
          end
        end
        system "clear"
        puts
        print "Add Another Item? (Y/N): "
        insert_again = $stdin.gets.chomp.downcase
        quit_option3 = true if insert_again == "n"
      end

  when "4"
    quit_option4 = false
    while quit_option4 != true do
      system "clear"
      library_item_hash = {}
      table = Terminal::Table.new title: 'BORROWED ITEMS LIST', headings: ['Borrower\'s Name', 'Item Title', 'Item Type', 'Date Borrowed', 'Due Date'], style: {:border_x => "=", :border_i => "*"} do |t|
        hash_with_duedate_key = {}
        array_of_items = []
        sorted_by_duedate = {}
        CSV.foreach(LIBRARY_ITEMS, headers: true) do |row|
          library_item = LibraryItem.from_csv_row(row)
          library_item_hash = library_item.instance_variables.each_with_object({}) { |var, hash| hash[var.to_s.delete("@")] = library_item.instance_variable_get(var) }
          array_of_items = []
          library_item_hash.each do |key, value|
          array_of_items << value
            if key == "due_date"
              hash_with_duedate_key[value] = array_of_items
            end
          end
        end
        sorted_by_duedate = hash_with_duedate_key.sort_by { |k,_| Date.strptime(k,"%d%m%Y") }
        sorted_by_duedate.each do |key, value|
          due_date_object = Date.strptime(value[4], '%d%m%Y')
          print_name = value[0]
          print_item_title = value[1]
          print_item_title = ColorizedString["#{value[1]}"].colorize(:background => :red).bold if due_date_object < Date.today
          print_item_title = ColorizedString["#{value[1]}"].colorize(:background => :yellow).bold.blink if due_date_object >= Date.today && due_date_object <= Date.today + 7
          print_item_type = "Book" if value[2] == "b"
          print_item_type = "CD" if value[2] == "c"
          print_item_type = "DVD" if value[2] == "d"
          print_item_type = "Magazine" if value[2] == "m"
          print_date_borrowed = Date.strptime(value[3], '%d%m%Y').strftime('%d%b%Y')
          print_due_date = Date.strptime(value[4], '%d%m%Y').strftime('%d%b%Y')
          print_due_date = ColorizedString["#{print_due_date}"].colorize(:background => :red).bold if due_date_object < Date.today
          print_due_date = ColorizedString["#{print_due_date}"].colorize(:background => :yellow).bold.blink if due_date_object >= Date.today && due_date_object <= Date.today + 7
          t.add_row [print_name, print_item_title, print_item_type, print_date_borrowed, print_due_date]
        end
      end
      puts
      puts table.to_s
      puts
      print "Go Back To Main Menu? (Y/N): "
      back_to_main = $stdin.gets.chomp.downcase
      quit_option4 = true if back_to_main == "y"
    end

  when "5"
    quit_option5 = false
    overdue_list_displayed = false
    while quit_option5 != true do
      if overdue_list_displayed == false
        system "clear"
        print "Enter Overdue Fine Per Day: $"
        overdue_fine_per_day = $stdin.gets.chomp.to_f
        print "Enter Maximum Fine: $"
        maximum_fine = $stdin.gets.chomp.to_f
      end
      system "clear"
      total_overdue_amount = 0
      table = Terminal::Table.new title: 'OVERDUE ITEMS LIST', headings: ['Borrower\'s Name', 'Item Title', 'Item Type', 'Overdue Fine'], style: {:border_x => "=", :border_i => "*"} do |t|
        CSV.foreach(LIBRARY_ITEMS, headers: true) do |row|
          library_item = LibraryItem.from_csv_row(row)
          library_item_hash = library_item.instance_variables.each_with_object({}) { |var, hash| hash[var.to_s.delete("@")] = library_item.instance_variable_get(var) }
          print_name = " "
          print_item_title = " "
          print_item_type = " "
          print_overdue_fine = " "
            library_item_hash.each do |key, value|
              print_name = value if key == "name"
              print_item_title = value if key == "item_title"
              print_item_type = "Book" if key == "item_type" && value == "b"
              print_item_type = "CD" if key == "item_type" && value == "c"
              print_item_type = "DVD" if key == "item_type" && value == "d"
              print_item_type = "Magazine" if key == "item_type" && value == "m"
              if key == "due_date"

                # Convert due date to date object and compare with current date

                due_date_object = Date.strptime(value, '%d%m%Y')
                if due_date_object < Date.today
                  days_overdue = Date.today - due_date_object
                  overdue_amount = days_overdue * overdue_fine_per_day
                  overdue_amount = maximum_fine if overdue_amount > maximum_fine
                  total_overdue_amount += overdue_amount
                  print_overdue_fine = "$#{sprintf "%.2f", overdue_amount}"
                  t.add_row [print_name, print_item_title, print_item_type, print_overdue_fine]
                end
              end
            end
        end
      end
      puts
      puts table.to_s
      puts
      puts ColorizedString["Total Fine is $#{sprintf "%.2f", total_overdue_amount}"].colorize(:background => :yellow).bold
      puts
      print "Go Back To Main Menu? (Y/N): "
      back_to_main = $stdin.gets.chomp.downcase
      overdue_list_displayed = true
      quit_option5 = true if back_to_main == "y"
    end

  when "0"
    quit_app = true
    system "clear"
  end
end
