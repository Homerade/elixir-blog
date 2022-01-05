## Router: scope path

How does changing scope paths work?

- how can they change? what do those changes do?
- you can put in any path and action you want as long as it has a proper method

eg. get "/whoknows", PostController, :index

- shows the same thing as /posts

Routes.post_path(@conn, :craziness)
get "/whoknows", PostController, :craziness <-- (which renders the same thing as :index)

- goes to /whoknows and shows the same thing as /posts

Breakdown:
post_path GET /posts BlogWeb.PostController :index
1)post_path 2)GET 3)/posts 4)BlogWeb.PostController 5):index
1) path helper
2) HTTP Method:
POST, PUT, PATCH, DELETE, OPTIONS, CONNECT, TRACE and HEAD
3) path
4) module that hosts the action (the controller)
5) action
get "/", PageController, :index

          page_path  GET     /                                      BlogWeb.PageController :index

resources "/posts", PostController:

          post_path  GET     /posts                                 BlogWeb.PostController :index
          post_path  GET     /posts/:id/edit                        BlogWeb.PostController :edit
          post_path  GET     /posts/new                             BlogWeb.PostController :new
          post_path  GET     /posts/:id                             BlogWeb.PostController :show
          post_path  POST    /posts                                 BlogWeb.PostController :create
          post_path  PATCH   /posts/:id                             BlogWeb.PostController :update
                     PUT     /posts/:id                             BlogWeb.PostController :update
          post_path  DELETE  /posts/:id                             BlogWeb.PostController :delete

What's the difference between these two?

          post_path  PATCH   /posts/:id                             BlogWeb.PostController :update
                     PUT     /posts/:id                             BlogWeb.PostController :update

PATCH only send data you want to update
PUT sends the entire payload, including any items that are not being changed: replacing the entire row
Implementation:

- specify PATCH method in a form and send partial data to be updated?
- the controller paths are the same so it should run through the controller action just like any other update

ex. <%= form_for @changeset, @action, [method: "patch"], fn f -> %>
 


----------


## Router: `only: ` & `except:`

`only:` or `except:` as part of a resource
What are they?
Resources provides all the standard HTTP methods. However, if we don't need all of them we can use the following to make adjustments:
:only and :except
eg resources "/posts", PostController, only: [:index, :show]


----------


## Plugs: Accepts

What does `accepts` plug do?
Part of the `:browser` pipeline shipped with Phoenix, the `plug :accepts, ["html"]` defines the request format or formats which will be accepted


----------


## Router: Nesting Resources

How can resources be nested?
usually based on DB relationship: many to one etc
eg 
many Posts to one User
one User to many Posts
resources "/users", UserController do
resources "/posts", PostController
end
we now have standard resources under a new path helper: user_post_path
in addition to resources under: user_path
the paths show the connection between users, a specific user :id, and posts are scoped to that user id
user_post_path GET /users/:user_id/posts HelloWeb.PostController :index
user_post_path GET /users/:user_id/posts/:id/edit HelloWeb.PostController :edit
user_post_path GET /users/:user_id/posts/new HelloWeb.PostController :new
user_post_path GET /users/:user_id/posts/:id HelloWeb.PostController :show
user_post_path POST /users/:user_id/posts HelloWeb.PostController :create
user_post_path PATCH /users/:user_id/posts/:id HelloWeb.PostController :update
PUT /users/:user_id/posts/:id HelloWeb.PostController :update
user_post_path DELETE /users/:user_id/posts/:id HelloWeb.PostController :delete
when calling scoped routes, extra arguments must be passed in in the correct order
For example the :show route:
user_post_path GET /users/:user_id/posts/:id HelloWeb.PostController :show
Routes.user_post_path(conn, :show, 42, 17)
in iex:
iex > alias HelloWeb.Endpoint
iex > HelloWeb.Router.Helpers.user_post_path(Endpoint, :show, 42, 17)
"/users/42/posts/17"
Any additional arguments added to the path will show up in the query string:
Routes.user_post_path(conn, :index, 42, active: true)

> "/users/42/posts?active=true”



----------


## Router: Pipelines

What are pipelines?
a grouping of plugs added to scopes to run certain processes on certain users or part of the app
What are they primarily used for?
How are they implemented?
in the router.ex file...
define a pipeline:
pipeline :browser do
plug :accepts, ["html"]
plug :fetch_session
plug :fetch_flash
plug :protect_from_forgery
plug :put_secure_browser_headers
end
Add it to a scope:
scope "/reviews" do
pipe_through :browser

    resources "/", HelloWeb.ReviewController

end
Add multiple piplelines:
scope "/reviews" do
pipe_through [:browser, :review_checks, :other_great_stuff]

    resources "/", HelloWeb.ReviewController

end
See also route forwarding: https://hexdocs.pm/phoenix/routing.html#forward


----------


## Plugs

explanations thus far on hex docs are confusing af


----------


## Router: scoping

Routes can be scoped under different path prefixes in order to group them together for different user groups or purposes
all paths under a scope have the given scope set at the root:
scope "/admin", HelloWeb.Admin do
pipe_through :browser
get "/reviews", ReviewController, :index
end
review_path GET /admin/reviews HelloWeb.Admin.ReviewController :index
This can also be helpful in sectioning off an app to show different parts to different users by changing the pipelines
scope "/", Web do
pipe_through([:browser, :logged_in_as_account_manager])

    get "/account-manager-dashboard", AccountManagerController, :dashboard
    get "/dashboard/client-list", AccountManagerController, :client_list

end
scope "/", Web do
pipe_through([:browser, :logged_in_as_admin])

    resources "/clients", ClientController do
      resources "/users", ClientUserController, only: [:new, :create, :index]
      resources "/projects", ProjectController, only: [:new, :create]
    end

end
if routes are duplicated or not put in the right order (eg individual paths before resources) we may get the following error:
`warning: this clause cannot match because a previous clause at line 16 always matches`


----------


## Router: `as:`

Additional information to this post: http://localhost:4000/posts/9
`as:` as a part of a resource
What is it?
`as:` is a name binding option to make route names easier to understand
What does it do?
How can it be used?
Use cases?
If we want to expose a route in different scopes / to multiple sets of users, if we simply add the same route to different scopes the path helpers end up the same and that is an problem.
scope "/", HelloWeb do
pipe_through :browser
get "/reviews", ReviewController, :index
end
scope "/admin", HelloWeb.Admin do
pipe_through :browser
get "/reviews", ReviewController, :index
end
This will result in:
review_path GET /reviews HelloWeb.ReviewController :index
review_path GET /admin/reviews HelloWeb.Admin.ReviewController :index
we can add `as: :admin` to the admin scope to differentiate it and namespace the path helper correctly:
scope "/admin", HelloWeb.Admin, as: :admin do
pipe_through :browser
get "/reviews", ReviewController, :index
end
admin_review_path GET /admin/reviews HelloWeb.Admin.ReviewController :index

