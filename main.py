from tkinter import *
import tkinter.ttk as ttk
import sqlite3
import datetime

db = sqlite3.connect('szpital.db')
cursor = db.cursor()

def insert_worker(entries):
    cursor.execute('''INSERT INTO PRACOWNICY VALUES(?,?,?,?,?,?,?,?,?,?,?)''',list(entries[0:11]))
    db.commit()

def last_worker():
    cursor.execute('''SELECT MAX(nr_pracownika) from PRACOWNICY''')
    id = cursor.fetchone()
    return ((id[0]))

def insert_doctor(entries):
    cursor.execute('''INSERT INTO LEKARZE VALUES(?,?,?,?,?)''', list(entries[0:5]))
    db.commit()

def insert_patient(entries):
    cursor.execute('''INSERT INTO PACJENCI VALUES(?,?,?,?,?,?,?,?,?,?)''',list(entries[0:10]))
    db.commit()

def insert_visit(entries):
    cursor.execute('''INSERT INTO Lekarz_Pacjent VALUES(?,?,?,?,?,?)''',list(entries[0:6]))
    db.commit()

def all_workers():
    cursor.execute('''select * from pracownicy;''')

    results = cursor.fetchall()
    return results

def all_patients():
    cursor.execute('''select * from pacjenci;''')

    results = cursor.fetchall()
    return results

def all_departments():
    cursor.execute('''select * from oddzialy;''')

    results = cursor.fetchall()
    return results

def all_doctors():
    cursor.execute('''select * from lekarze;''')

    results = cursor.fetchall()
    return results

def all_diseases():
    cursor.execute('''select * from choroby;''')

    results = cursor.fetchall()
    return results

def all_tests():
    cursor.execute('''select * from testy;''')

    results = cursor.fetchall()
    return results

def all_items():
    cursor.execute('''select * from srodki;''')

    results = cursor.fetchall()
    return results

def link_worker_department(entries):
    cursor.execute('''INSERT INTO Pracownik_Oddzial VALUES(?,?,?)''',
               (int(entries[0]),int(entries[1]),int(entries[2])))
    db.commit()
def link_worker_doctor(entries):
    cursor.execute('''INSERT INTO Pracownik_Lekarz VALUES(?,?)''',
               (int(entries[0]),int(entries[1])))
    db.commit()



class Window(Frame):

    def __init__(self, master=None):
        Frame.__init__(self, master)

        self.master = master

        self.init_window()
        self.frame = Frame(master)
        self.frame.grid()


        self.bottom_frame = Frame(master)
        self.bottom_frame.grid(sticky='S')

        self.result_frame = Frame(master)
        self.result_frame.grid()

        self.entries = []
        self.entries_list = []

    # Creation of init_window
    def init_window(self):
        self.master.title("Szpital")
        self.grid()

        menu = Menu(self.master)
        self.master.config(menu=menu)

        # Menu Dodaj do bazy danych
        add = Menu(menu)
        add.add_command(label="Dodaj pracownika", command=self.add_worker)
        add.add_command(label="Dodaj pacjenta", command=self.add_patient)
        add.add_command(label="Dodaj lekarza", command=self.add_doctor)
        add.add_command(label="Dodaj wizytę" , command=self.add_visit)

        menu.add_cascade(label="Dodaj ... ", menu=add)

        # Menu Powiązań
        link = Menu(menu)
        link.add_command(label="Powiąż pracownika z oddziałem", command=self.link_worker_department)
        link.add_command(label="Powiąż lekarza z pracownikiem szpitala", command=self.link_worker_doctor)

        menu.add_cascade(label="Powiąż ... ", menu=link)

        # Menu Wyświetleń
        show = Menu(menu)
        show.add_command(label="Wyświetl wszystkich pracowników", command=self.show_workers)
        show.add_command(label="Wyświetl wszystkich pacjentów", command=self.show_patients)

        menu.add_cascade(label="Wyświetl ... ", menu=show)

        # Menu Exit
        exit = Menu(menu)
        exit.add_command(label="Exit", command=self.client_exit)
        menu.add_cascade(label="Exit", menu=exit)

    def clear_frame(self):
        for widget in self.frame.winfo_children():
            widget.destroy()

    def clear_bottom_frame(self):
        for widget in self.bottom_frame.winfo_children():
            widget.destroy()

    def clear_all(self):
        for widget in self.frame.winfo_children():
            widget.destroy()
        for widget in self.bottom_frame.winfo_children():
            widget.destroy()
        for widget in self.result_frame.winfo_children():
            widget.destroy()

    def make_fields(self,fields,text='',my_row=0):

        #Funckja tworząca pola do wpisania.
        if(my_row==0):
            self.clear_all()
        self.entries = []

        MSG = Message(self.frame,text=text, width=200)
        MSG.grid(row=0, column=1, sticky='N')
        print(my_row)
        for i in range(len(self.fields)):
            L1 = Label(self.frame, text=self.fields[i])
            L1.grid(column=1, row=1 + i,sticky='e')
            if(fields[i]=="Nr pracownika :"):
                next_id=last_worker()+1
                print(next_id)
                E1 = Entry(self.frame, bd=5)
                E1.insert(END, next_id)
                E1.config(state='disabled')
                E1.grid(column=2, row=1 + i, sticky='e')
            else:
                E1 = Entry(self.frame, bd=5)
                E1.grid(column=2, row=1 + i,sticky='e')
            self.entries.append(E1)

        button = Button(self.frame, text="Zapisz", command=self.save_entries).grid(row=16, column=1)



    def save_entries(self):
        int_fields=['Kod pocztowy :','Nr domu :','Nr mieszkania :','PESEL :','ID lekarza :',
                    'Numer tel. :','Ilość godz/tydzień :']
        notnull_fields=[ 'Imię :', 'Nazwisko :', 'Stanowisko :',
                  'Miejscowość :', 'Kod pocztowy :', 'Ulica :', 'Nr domu :',
                  'Data urodzenia :','Krewna osoba :','PESEL :','Specjalność :',
                         'Ilość godz/tydzień :','Data :', 'Godz :', 'Wynik :']
        dates_fields=['Data :','Data urodzenia :']

        #Funkcja zapisująca wpisane dane
        self.clear_bottom_frame()
        self.entries_list = []

        for label in self.frame.grid_slaves():
            if int(label.grid_info()["column"]) == 3:
                label.grid_forget()
        for i in range(len(self.fields)):

            current_entry = self.entries[i].get()

            L2 = Label(self.frame, text="", fg="red")
            L2.grid(column=3, row=1 + i, sticky='w')
            L1 = Label(self.frame, text=self.fields[i], fg='red')
            L1.grid(column=1, row=1 + i, sticky='e')

            if (self.fields[i] in  notnull_fields and current_entry == ''):
                L1.config( fg='red')
                L2.config(text='Pole wymagane', fg='red')

            elif (self.fields[i] in int_fields):
                try:
                    L1.config(fg='black')
                    current_entry = int(current_entry)
                    L2.config(text='OK', fg='green')

                except:
                    L1.config(fg='red')
                    L2.config(text='Wartość musi być liczbowa', fg='red')

            elif (self.fields[i] in dates_fields):
                try:
                    datetime.datetime.strptime(current_entry, '%Y-%m-%d')
                    L1.config(fg='black')
                    L2.config(text='OK', fg='green')
                except ValueError:
                    L1.config(fg='red')
                    L2.config(text='Format daty RRRR-MM-DD', fg='red')

            else:
                L1.config(fg='black')
                L2.config(text='OK', fg='green')


            if (current_entry == '' and self.fields[i] not in notnull_fields):
                current_entry = None
                L1.config(fg='black')
                L2.config(text='OK', fg='green')

            if (self.fields[i] == 'Pensja :'):
                try:
                    current_entry = int(current_entry)
                    if current_entry > 0:
                        E1 = Entry(self.frame, bd=5)
                        E1.insert(END,'')
                        E1.config(state='disabled')
                        E1.grid(column=2, row=2 + i, sticky='e')
                except:
                    L1 = Label(self.frame, text=self.fields[i], fg='red')
                    L1.grid(column=1, row=1 + i, sticky='e')
                    L2.config(text='Pensja LUB stawka musi być większa od 0', fg='red')

            if (self.fields[i] == 'Stawka godzinowa :'):
                try:
                    if(self.entries_list[i-1]=='' or self.entries_list[i-1]==None):
                        current_entry = int(current_entry)
                        if current_entry > 0:
                            E1 = Entry(self.frame, bd=5)
                            E1.insert(END,'')
                            E1.config(state='disabled')
                            E1.grid(column=2, row=i, sticky='e')

                except:
                    L1 = Label(self.frame, text=self.fields[i], fg='red')
                    L1.grid(column=1, row=1 + i, sticky='e')
                    L2.config(text='Pensja LUB stawka musi być większa od 0', fg='red')



            self.entries_list.append(current_entry)
        print(self.entries_list)
        #warunek dla pensji i stawki



        tem_list=[]

        try:
            if (self.option==1):
                insert_worker(self.entries_list)
                MSG = Message(self.bottom_frame, text="Dodano pracownika", width=200)
                MSG.grid(row=16, column=7)

            elif (self.option==2):
                insert_patient(self.entries_list)
                MSG = Message(self.bottom_frame, text="Dodano pacjenta", width=200)
                MSG.grid(row=16, column=7)
            elif (self.option==3):
                insert_doctor(self.entries_list)
                MSG = Message(self.bottom_frame, text="Dodano lekarza", width=200)
                MSG.grid(row=16, column=7)
            elif (self.option==4):
                if (self.selected_id[0]!='' and self.selected_id[1]!='' and self.selected_id[2]!=''):
                    tem_list.append(self.selected_id[0])
                    tem_list.append(self.selected_id[1])
                    tem_list.append(self.entries_list[0])
                    tem_list.append(self.entries_list[1])
                    tem_list.append(self.entries_list[2])
                    tem_list.append(self.selected_id[2])
                    self.entries_list=tem_list
                    print(self.entries)
                    insert_visit(self.entries_list)
                    MSG = Message(self.bottom_frame, text="Dodano wizytę", width=200)
                    MSG.grid(row=16, column=7)
                else:
                    MSG = Message(self.bottom_frame, text="Wybierz lekarza pacjenta i chorobę", width=200)
                    MSG.grid(row=16, column=7)

            elif (self.option==5):
                tem_list.append(self.selected_id[0])
                tem_list.append(self.selected_id[1])
                tem_list.append(self.entries_list[0])
                self.entries_list = tem_list
                link_worker_department(self.entries_list)
                MSG = Message(self.bottom_frame, text="Powiązano lekarza z oddziałem", width=200)
                MSG.grid(row=16, column=7)
                print("ok")
            elif (self.option==6):
                tem_list.append(self.selected_id[0])
                tem_list.append(self.selected_id[1])
                self.entries_list = tem_list
                link_worker_doctor(self.entries_list)
                MSG = Message(self.bottom_frame, text="Powiązano lekarza z pracownikiem", width=200)
                MSG.grid(row=16, column=7)
                print("ok")
        except:
            MSG = Message(self.bottom_frame, text="Popraw wpis", width=200)
            MSG.grid(row=16, column=7)



    def add_worker(self):
        self.option = 1
        self.fields = ['Nr pracownika :', 'Imię :', 'Nazwisko :', 'Stanowisko :',
                  'Miejscowość :', 'Kod pocztowy :', 'Ulica :', 'Nr domu :',
                  'Nr mieszkania :', 'Pensja :', 'Stawka godzinowa :']

        self.make_fields(self.fields,text="Wypełnij pola")

    def add_patient(self):
        self.option = 2
        self.fields = ['PESEL :', 'Imię :', 'Nazwisko :', 'Data urodzenia :',
                  'Miejscowość :', 'Kod pocztowy :', 'Ulica :', 'Nr domu :',
                  'Nr mieszkania :', 'Krewna osoba :']

        self.make_fields(self.fields,text="Wypełnij pola")

    def add_doctor(self):
        self.option = 3
        self.fields = ['ID lekarza :', 'Imię :', 'Nazwisko :', 'Specjalność :',
                  'Numer tel. :']

        self.make_fields(self.fields,text="Wypełnij pola")

    def add_visit(self):
        self.option = 4
        self.selected_id=[]
        self.clear_all()
        self.all_comboboxes = []


        results = all_doctors()
        self.make_combobox('Wybierz lekarza :', results)

        results = all_patients()
        self.make_combobox('Wybierz pacjenta :', results, my_row=2)

        results = all_diseases()
        self.make_combobox('Wybierz chorobe :', results, my_row=4)

        self.fields = ["Data :", "Godz :", "Wynik :"]
        self.make_fields(self.fields, text="Wypełnij pola", my_row=14)


    def print_results(self,results,my_height=10):
        result = Listbox(self.result_frame)
        result.grid(row=2, column=0)

        listbox_scroll = Scrollbar(self.result_frame, orient="vertical", command=result.yview)
        listbox_scroll.grid(row=2, column=1)
        result.configure(yscrollcommand=listbox_scroll.set, width=100, height=my_height)

        for x in results:
            result.insert(END, x)



    def make_combobox(self,my_text,my_results,my_row=0):
        L0 = Label(self.frame, text=my_text)
        L0.grid(column=0, row=0+my_row)

        cb = ttk.Combobox(self.frame, values=my_results, width=65)
        cb.grid(column=0,row=1+my_row)
        cb.bind('<<ComboboxSelected>>', self.on_select)

        self.all_comboboxes.append(cb)

    def on_select(self,event=None):
        print('----------------------------')
        self.selected_id=[]
        if event:  # <-- this works only with bind because `command=` doesn't send event
            print("event.widget:", event.widget.get())

        for i, x in enumerate(self.all_comboboxes):
            line=x.get()
            self.selected_id.append((line.split(' '))[0])

        print(self.selected_id)

    def link_worker_department(self):
        self.option=5
        self.clear_all()
        self.all_comboboxes = []

        results = all_workers()
        self.make_combobox('Wybierz pracownika :',results)

        results = all_departments()
        self.make_combobox('Wybierz oddział :', results, my_row=2)

        self.fields = ["Ilość godz/tydzień :"]
        self.make_fields(self.fields, text="Wypełnij pola", my_row=14)

        # warunek dla liczby godz.!

        #b = Button(self.frame, text="Powiąż", command=self.on_select)
        #b.grid(column=0,row=14)

    def link_worker_doctor(self):
        self.option = 6
        self.clear_all()
        self.all_comboboxes = []

        results = all_workers()
        self.make_combobox('Wybierz pracownika: ',results)

        results = all_doctors()
        self.make_combobox('Wybierz lekarza: ', results, my_row=4)

        self.fields=[]
        self.make_fields(self.fields, my_row=14)

    def show_workers(self):
        self.clear_all()

        L0 = Label(self.frame, text='Lista pracowników:')
        L0.grid(column=0, row=0)

        results = all_workers()
        self.print_results(results,20)

    def show_patients(self):
        self.clear_all()

        L0 = Label(self.frame, text='Lista pacjentów:')
        L0.grid(column=0, row=0)

        results = all_patients()
        self.print_results(results,20)

    def client_exit(self):
        exit()

#----------------
root = Tk()

root.geometry("800x400")

# creation of an instance
app = Window(root)

# mainloop
root.mainloop()

db.close()