# This program will generate traffic for ACME Fitness Shop App. It simulates both Authenticated and Guest user scenarios. You can run this program either from Command line or from
# the web based UI. Refer to the "locust" documentation for further information. 

from locust import HttpUser, TaskSet, task, User
import random
import logging

class UserBehavior(TaskSet):

    def on_start(self):
        self.home()

    @task(3)
    def home(self):
        logging.info("Accessing Home Page")
        self.client.get("/")

    @task(3)
    def findOwners(self):
        logging.info("Finding Owners")
        self.client.get("/owners/find")

    @task(3)
    def listVets(self):
        logging.info("Listing Vets")
        self.client.get("/vets.html")

    @task(3)
    def searchOwners(self):
        logging.info("Searching Owners")
        self.client.get("owners?lastName=")

    @task(3)
    def viewOwner(self):
        logging.info("Viewing Single Owner")
        self.client.get("/owners/3")

    @task(1)
    def genError(self):
        logging.info("Generating Error")
        self.client.get("/oups")

class WebSiteUser(HttpUser):

    tasks = [UserBehavior]
    userid = ""
    min_wait = 2000
    max_wait = 10000
    


