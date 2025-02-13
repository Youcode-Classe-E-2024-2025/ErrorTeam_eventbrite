<?php

use App\Controllers\Front\HomeController;
use App\Controllers\Front\ArticleController;
use App\Controllers\Front\ContactController;
use App\Controllers\Front\AuthController;
use App\Controllers\Back\DashboardController; 
use App\Controllers\Back\UserController;
use App\Controllers\Front\EventController;
use App\Controllers\Front\OrganiserController;
use App\Controllers\Front\ReservationController;
use App\Core\Router;
use App\Controllers\Back\ProfileController;


$router = new Router();

$router->addRoute('GET', '/', HomeController::class, 'index');
$router->get('/signup', AuthController::class, 'signupForm', 'signup.form');
$router->post('/signup', AuthController::class, 'signup', 'signup.submit');
$router->get('/login', AuthController::class, 'loginForm', 'login.form');
$router->post('/login', AuthController::class, 'login', 'login.submit');
$router->get('/logout', AuthController::class, 'logout', 'logout');
$router->get('/admin/dashboard', DashboardController::class, 'index', 'admin.dashboard');
$router->get('/admin/users', UserController::class, 'index', 'admin.users');
$router->get('/profile', App\Controllers\Front\ProfileController::class, 'index', 'profile.index');
$router->get('/profile/update', App\Controllers\Front\ProfileController::class, 'update', 'profile.update');
$router->post('/profile/update', App\Controllers\Front\ProfileController::class, 'update', 'profile.update');
$router->get('/events', EventController::class, 'index', 'events.index');
$router->get('/myevents', OrganiserController::class, 'events', 'events.index');
$router->get('/events/{id}', EventController::class, 'show', 'events.show');
$router->get('/delete-event/{id}', OrganiserController::class, 'deleteEvent', 'events.show');
$router->post('/create-event', OrganiserController::class, 'createEvent', 'events.show');
$router->get('/events/{event_id}/reservations/create', ReservationController::class, 'createForm', 'reservations.create.form');
$router->post('/events/{event_id}/reservations/create', ReservationController::class, 'create', 'reservations.create');
$router->get('/events/{event_id}/reservations/payment', ReservationController::class, 'paymentForm', 'reservations.payment.form');

return $router;