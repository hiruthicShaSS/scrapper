import pickle
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

from colorama import init, Fore

init()


class Products:
    def __init__(self, filename, email, product):
        self.products = {}
        self.filename = filename
        self.email = email
        self.product = product
        self.modules = list()
        self.server = smtplib.SMTP('smtp.gmail.com', 587)
        self.server.starttls()
        self.server.login("idiotpyscripts@gmail.com", "wwjbvjahwcgzmutq")

    def write_to_file(self, MODULE):
        with open(self.filename, "ab") as file:
            pickle.dump(self.products, file)
            print(Fore.WHITE, f"[{MODULE}] - Write completed => ", self.filename)

    def add(self, key, value):
        self.products[key] = value

    def get_products_length(self):
        return len(self.products.keys())

    def add_module(self, module):
        self.modules.append(module)

    def completed(self, module):
        self.modules.remove(module)
        print(f"[{module}] - returned")

        msg = MIMEMultipart('alternative')
        msg['Subject'] = "Scrap completed"
        msg['From'] = "idiotpyscripts@gmail.com"
        msg['To'] = self.email
        text = "Your scrap query " + f"'{module}'" + " was successfully completed scrapping. Please get your data from the app "
        html = """\
        <html>
        <head>
            <title>Scraping completed</title>
        </head>
        <body>
            <style>
                body {
                    background-color: black;
                }
                h4 {
                    color: aquamarine;
                }
                button {
                    height: 40px;
                    width: 100px;
                    color: white;
                    background-color: blue;
                    border-radius: 10px;
                    border-color: white;
                    margin-left: 50%;
                    margin-right: 50%;
                }
            </style>
            <h4>Your scrap query <placeholder> is ready http://productscrapper.com/results</h4>
            <p><strong>Remember</strong>, if you have closed the app or the app was stopped working in the background you will lose the data.</p>
            <button onclick="window.location.href = 'http://www.google.com';">Get data</button>
        </body>
        </html>
        """
        part1 = MIMEText(text)
        part2 = MIMEText(html, 'html')
        msg.attach(part1)
        msg.attach(part2)

        self.server.sendmail("idiotpyscripts@gmail.com", self.email, msg.as_string())
        self.server.quit()


pro = Products("dgfdg", "predatorsha2002@gmail.com", "ram")
pro.add_module("Flipkart")
pro.completed("Flipkart")
