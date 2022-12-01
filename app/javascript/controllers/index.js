// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import HelloController from "./hello_controller"
application.register("hello", HelloController)

import HomePageSelectionController from "./home_page_selection_controller"
application.register("home-page-selection", HomePageSelectionController)

import MapController from "./map_controller"
application.register("map", MapController)

import SharingSubscriptionController from "./sharing_subscription_controller"
application.register("sharing-subscription", SharingSubscriptionController)
