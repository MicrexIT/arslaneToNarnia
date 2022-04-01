defmodule ArslaneToNarnia.Components.LandingPage do
  @moduledoc """
  A set of components for use in a landing page.
  """
  use ArslaneToNarniaWeb, :component

  # prop menu_items, :list
  # prop li_class, :string
  # prop a_class, :string
  defp list_menu_items(assigns) do
    ~H"""
    <%= for menu_item <- @menu_items do %>
      <li class={@li_class}>
        <.link
          to={menu_item.path}
          class={@a_class}
          link_type="a"
          method={if menu_item[:method], do: menu_item[:method], else: nil}
        >
          <%= menu_item.label %>
        </.link>
      </li>
    <% end %>
    """
  end

  # prop main_menu_items, :list
  # prop user_menu_items, :list
  # prop current_user, :any
  def header(assigns) do
    assigns =
      assigns
      |> assign_new(:main_menu_items, fn -> [] end)
      |> assign_new(:user_menu_items, fn -> [] end)

    ~H"""
    <header
      x-data="{mobile: false}"
      class="fixed top-0 left-0 z-30 w-full transition duration-500 ease-in-out md:sticky dark:bg-gray-900 semi-translucent"
    >
      <.container>
        <div class="flex flex-wrap items-center h-16 md:h-18">
          <div class="lg:w-3/12">
            <div class="flex items-center">
              <.link class="inline-block ml-1 text-2xl font-bold leading-none" to="/">
                <.logo variant="dark" class="block h-10 dark:hidden" />
                <.logo variant="light" class="hidden h-10 dark:block" />
              </.link>
            </div>
          </div>

          <div class="hidden lg:w-6/12 md:block">
            <ul class="justify-center md:flex">
              <.list_menu_items
                li_class="ml-8 lg:mx-4 xl:mx-6"
                a_class="block font-medium leading-7 capitalize dark:text-gray-100 menu-item"
                menu_items={@main_menu_items}
              />
            </ul>
          </div>

          <div class="flex items-center justify-end ml-auto lg:w-3/12">
            <div class="mr-3">
              <.language_select
                current_locale={Gettext.get_locale(ArslaneToNarniaWeb.Gettext)}
                language_options={Application.get_env(:arslane_to_narnia, :language_options)}
              />
            </div>
            <div class="mr-4">
              <ArslaneToNarniaWeb.Components.ColorSchemeSwitch.color_scheme_switch />
            </div>

            <div class="hidden md:block">
              <.user_menu_dropdown
                user_menu_items={@user_menu_items}
                current_user_name={if @current_user, do: @current_user.name, else: nil}
              />
            </div>

            <div
              @click="mobile = !mobile"
              class="relative inline-block w-5 h-5 cursor-pointer md:hidden"
            >
              <svg
                :class="{ 'opacity-1' : !mobile, 'opacity-0' : mobile }"
                width="24"
                height="24"
                fill="none"
                class="absolute -mt-3 -ml-3 transform top-1/2 left-1/2"
              >
                <path
                  d="M4 8h16M4 16h16"
                  stroke="currentColor"
                  stroke-width="2"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                />
              </svg>

              <svg
                :class="{ 'opacity-0' : !mobile }"
                width="24"
                height="24"
                fill="none"
                class="absolute -mt-3 -ml-3 transform opacity-0 top-1/2 left-1/2 scale-80"
              >
                <path
                  d="M6 18L18 6M6 6l12 12"
                  stroke="currentColor"
                  stroke-width="2"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                />
              </svg>
            </div>
          </div>
        </div>

        <div :class="{ 'block' : mobile, 'hidden' : !mobile }" class="md:hidden">
          <hr class="border-primary-900 border-opacity-10 dark:border-gray-700" />
          <ul class="py-6">
            <.list_menu_items
              li_class="mb-2 last:mb-0"
              a_class="inline-block font-medium capitalize menu-item"
              menu_items={@main_menu_items}
            />

            <%= if @current_user do %>
              <div class="pt-4 pb-3">
                <div class="flex items-center">
                  <div class="flex-shrink-0">
                    <%= if @current_user.name do %>
                      <.avatar name={@current_user.name} size="sm" random_color />
                    <% else %>
                      <.avatar size="sm" />
                    <% end %>
                  </div>
                  <div class="ml-3">
                    <div class="text-base font-medium text-gray-800 dark:text-gray-500">
                      <%= @current_user.name %>
                    </div>
                  </div>
                </div>
              </div>
            <% end %>

            <.list_menu_items
              li_class="mb-2 last:mb-0"
              a_class="inline-block font-medium capitalize menu-item"
              menu_items={@user_menu_items}
            />
          </ul>
        </div>
      </.container>
    </header>
    """
  end

  def hero(assigns) do
    ~H"""
    <section
      id="hero"
      class="bg-gradient-to-b from-white to-slate-100 dark:from-gray-900 dark:to-gray-800"
    >
      <.container class="relative z-10 py-20">
        <div class="flex flex-wrap items-center -mx-3">
          <div class="w-full px-3 lg:w-1/2">
            <div class="py-12">
              <div class="max-w-lg mx-auto mb-8 text-center lg:max-w-md lg:mx-0 lg:text-left">
                <.h1 class="fade-in-animation">
                  <%= render_slot(@title) %>
                </.h1>

                <p
                  class="mt-6 text-lg leading-relaxed text-slate-500 dark:text-slate-400 fade-in-animation"
                >
                  <%= render_slot(@description) %>
                </p>
              </div>
              <div class="space-x-2 text-center lg:text-left fade-in-animation">
                <%= render_slot(@action_buttons) %>
              </div>
            </div>
          </div>
          <div class="w-full px-3 mb-12 lg:w-1/2 lg:mb-0">
            <div class="flex items-center justify-center lg:h-128">
              <img
                id="hero-image"
                class="fade-in-from-right-animation lg:max-w-lg max-h-[500px]"
                src={@image_src}
                alt=""
              />
            </div>
          </div>
        </div>

        <div class="mt-40">
          <.logo_cloud />
        </div>
      </.container>
    </section>
    """
  end

  def logo_cloud(assigns) do
    ~H"""
    <div id="logo-cloud" class="container px-4 mx-auto">
      <h2 class="mb-10 text-2xl text-center text-gray-500 fade-in-animation dark:text-gray-300">
        <%= gettext("❤️ by friends all over the world") %>
      </h2>

      <div class="flex flex-wrap -m-4">
         <div class="flex flex-wrap flex-row justify-center">
          <div class="p-4 lg:p-8">
           <.avatar size="xl" src="/images/IMG_0031.jpg"/>
          </div>
          <div class="p-4 lg:p-8">
           <.avatar size="xl" src="/images/IMG_0031.jpg"/>
          </div>

          <div class="p-4 lg:p-8">
           <.avatar size="xl" src="/images/IMG_0031.jpg"/>
          </div>
          <div class="p-4 lg:p-8">
           <.avatar size="xl" src="/images/IMG_0031.jpg"/>
          </div>
          <div class="p-4 lg:p-8">
           <.avatar size="xl" src="/images/IMG_0031.jpg"/>
          </div>
          <div class="p-4 lg:p-8">
           <.avatar size="xl" src="/images/IMG_0031.jpg"/>
          </div>
          <div class="p-4 lg:p-8">
           <.avatar size="xl" src="/images/IMG_0031.jpg"/>
          </div>
          <div class="p-4 lg:p-8">
           <.avatar size="xl" src="/images/IMG_0031.jpg"/>
          </div>
          <div class="p-4 lg:p-8">
           <.avatar size="xl" src="/images/IMG_0031.jpg"/>
          </div>
          <div class="p-4 lg:p-8">
           <.avatar size="xl" src="/images/IMG_0031.jpg"/>
          </div>
          <div class="p-4 lg:p-8">
           <.avatar size="xl" src="/images/IMG_0031.jpg"/>
          </div>
          <div class="p-4 lg:p-8">
           <.avatar size="xl" src="/images/IMG_0031.jpg"/>
          </div>
          <div class="p-4 lg:p-8">
           <.avatar size="xl" src="/images/IMG_0031.jpg"/>
          </div>
          <div class="p-4 lg:p-8">
           <.avatar size="xl" src="/images/IMG_0031.jpg"/>
          </div>
          <div class="p-4 lg:p-8">
           <.avatar size="xl" src="/images/IMG_0031.jpg"/>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def features(assigns) do
    assigns =
      assigns
      |> assign_new(:features, fn -> [] end)

    ~H"""
    <section
      id="features"
      class="relative z-10 py-16 text-center transition duration-500 ease-in-out bg-white md:py-32 dark:bg-gray-900 dark:text-white"
    >
      <.container class="relative z-10">
        <div class="mx-auto mb-16 md:mb-20 lg:w-7/12 stagger-fade-in-animation">
          <div class="mb-5 text-3xl font-bold md:mb-7 md:text-5xl fade-in-animation">Features</div>
          <div class="text-lg font-light anim md:text-2xl fade-in-animation">
            Hit the ground running on your next web application project.
          </div>
        </div>

        <div class="grid md:grid-cols-3 stagger-fade-in-animation gap-y-8">
          <%= for feature <- @features do %>
            <div class="px-8 mb-10 border-gray-200 md:px-16 fade-in-animation last:border-0">
              <div class="flex justify-center mb-4 md:mb-6">
                <span class="flex items-center justify-center w-12 h-12 rounded-md bg-primary-600">
                  <Heroicons.Outline.render icon={feature.icon} class="w-6 h-6 text-white" />
                </span>
              </div>
              <div class="mb-2 text-lg font-medium md:text-2xl">
                <%= feature.title %>
              </div>
              <p class="font-light leading-normal md:text-lg">
                <%= feature.description %>
              </p>
            </div>
          <% end %>
        </div>
      </.container>
    </section>
    """
  end

  def about_us(assigns) do
    assigns =
      assigns
      |> assign_new(:inverted, fn -> false end)
      |> assign_new(:background_color, fn -> "primary" end)
      |> assign_new(:inner_block, fn -> nil end)

    ~H"""
    <section
      id="about-us"
      class="overflow-hidden transition duration-500 ease-in-out bg-gray-50 md:pt-0 dark:bg-gray-800 dark:text-white"
      data-offset="false"
    >
      <.container>
        <div
          class={
            "flex flex-wrap items-center gap-20 py-32 md:flex-nowrap text-center md:text-end"
          }
        >
          <div class="stagger-fade-in-animation text-center">
            <div class="mb-5 text-3xl font-bold md:mb-7 fade-in-animation md:text-5xl">
              <%= @title %>
            </div>

            <div class="space-y-4 text-md font-light md:text-xl md:space-y-5 fade-in-animation">
               <%= @description %>
            </div>
            <div class="space-y-4 text-md font-bold italic md:text-xl md:space-y-5 fade-in-animation my-12">
              <%= for entry <- @poem_entries do %>
                 <p class="">
                  <%= entry %>
                 </p>
              <% end %>
              <p class="mt-1">
                <%= @poem_signature %>
              </p>
            </div>
            <%= if @inner_block do %>
              <div class="fade-in-animation">
                <%= render_slot(@inner_block) %>
              </div>
            <% end %>
          </div>
        </div>
      </.container>
    </section>
    """
  end


  def solo_feature(assigns) do
    assigns =
      assigns
      |> assign_new(:inverted, fn -> false end)
      |> assign_new(:background_color, fn -> "primary" end)
      |> assign_new(:inner_block, fn -> nil end)

    ~H"""
    <section
      id="benefits"
      class="overflow-hidden transition duration-500 ease-in-out bg-gray-50 md:pt-0 dark:bg-gray-800 dark:text-white"
      data-offset="false"
    >
      <.container>
        <div
          class={
            "#{if @inverted, do: "flex-row-reverse", else: ""} flex flex-wrap items-center gap-20 py-32 md:flex-nowrap"
          }
        >
          <div class="md:w-1/2 stagger-fade-in-animation">
            <div class="mb-5 text-3xl font-bold md:mb-7 fade-in-animation md:text-5xl">
              <%= @title %>
            </div>

            <div class="space-y-4 text-lg font-light md:text-xl md:space-y-5">
              <p class="fade-in-animation">
                <%= @description %>
              </p>
            </div>
            <%= if @inner_block do %>
              <div class="fade-in-animation">
                <%= render_slot(@inner_block) %>
              </div>
            <% end %>
          </div>

          <div class="w-full md:w-1/2 md:mt-0">
            <div
              class={
                "#{if @background_color == "primary", do: "from-primary-200 to-primary-600 bg-primary-animation"} #{if @background_color == "secondary", do: "from-secondary-200 to-secondary-600 bg-secondary-animation"} relative flex items-center justify-center w-full p-16 bg-gradient-to-r rounded-3xl"
              }
            >
              <img
                class="z-10 w-full fade-in-animation solo-animation max-h-[500px]"
                src={@image_src}
                alt="Screenshot"
              />
            </div>
          </div>
        </div>
      </.container>
    </section>
    """
  end

  def testimonials(assigns) do
    assigns =
      assigns
      |> assign_new(:testimonials, fn -> [] end)

    ~H"""
    <section
      id="testimonials"
      class="relative z-10 transition duration-500 ease-in-out bg-white py-36 dark:bg-gray-900"
    >
      <div class="overflow-hidden content-wrapper">
        <.container class="relative z-10">
          <div class="mb-5 text-center md:mb-12 section-header stagger-fade-in-animation">
            <div class="mb-3 text-3xl font-bold leading-none md:mb-5 fade-in-animation md:text-5xl">
              Testimonials
            </div>
          </div>

          <div class="solo-animation fade-in-animation flickity">
            <%= for testimonial <- @testimonials do %>
              <.testimonial_panel {testimonial} />
            <% end %>
          </div>
        </.container>
      </div>
    </section>
    """
  end

  def testimonial_panel(assigns) do
    ~H"""
    <div
      class="w-full p-6 mr-10 overflow-hidden text-gray-700 transition duration-500 ease-in-out rounded-lg shadow-lg md:p-8 md:w-8/12 lg:w-5/12 bg-primary-50 dark:bg-gray-700 dark:text-white carousel-cell last:mr-0"
    >
      <blockquote class="mt-6 md:flex-grow md:flex md:flex-col">
        <div class="relative text-lg font-medium md:flex-grow">
          <svg
            class="absolute top-[-20px] left-0 w-8 h-8 transform -translate-x-3 -translate-y-2 text-primary-500"
            fill="currentColor"
            viewBox="0 0 32 32"
            aria-hidden="true"
          >
            <path
              d="M9.352 4C4.456 7.456 1 13.12 1 19.36c0 5.088 3.072 8.064 6.624 8.064 3.36 0 5.856-2.688 5.856-5.856 0-3.168-2.208-5.472-5.088-5.472-.576 0-1.344.096-1.536.192.48-3.264 3.552-7.104 6.624-9.024L9.352 4zm16.512 0c-4.8 3.456-8.256 9.12-8.256 15.36 0 5.088 3.072 8.064 6.624 8.064 3.264 0 5.856-2.688 5.856-5.856 0-3.168-2.304-5.472-5.184-5.472-.576 0-1.248.096-1.44.192.48-3.264 3.456-7.104 6.528-9.024L25.864 4z"
            >
            </path>
          </svg>
          <p class="relative">
            <%= @content %>
          </p>
        </div>
        <footer class="mt-8">
          <div class="flex items-start">
            <div class="inline-flex flex-shrink-0 border-2 border-white rounded-full">
              <img class="w-12 h-12 rounded-full" src={@image_src} alt="" />
            </div>
            <div class="ml-4">
              <div class="text-base font-medium"><%= @name %></div>
              <div class="text-base font-semibold"><%= @title %></div>
            </div>
          </div>
        </footer>
      </blockquote>
    </div>
    """
  end

  def pricing(assigns) do
    assigns =
      assigns
      |> assign_new(:plans, fn -> [] end)

    ~H"""
    <section
      id="pricing"
      class="py-24 text-gray-700 transition duration-500 ease-in-out md:py-32 dark:bg-gray-800 bg-gray-50 dark:text-white stagger-fade-in-animation"
    >
      <.container>
        <div class="mx-auto mb-16 text-center md:mb-20 lg:w-7/12 ">
          <div class="mb-5 text-3xl font-bold md:mb-7 md:text-5xl fade-in-animation">Pricing</div>
          <div class="text-lg font-light anim md:text-2xl fade-in-animation">
            Simple, transparent pricing that adapts to the size of your company.
          </div>
        </div>

        <div class="grid items-start max-w-sm gap-8 mx-auto lg:grid-cols-3 lg:gap-6 lg:max-w-none">
          <%= for plan <- @plans do %>
            <.pricing_table {plan} />
          <% end %>
        </div>
      </.container>
    </section>
    """
  end

  def pricing_table(assigns) do
    assigns =
      assigns
      |> assign_new(:most_popular, fn -> false end)
      |> assign_new(:currency, fn -> "$" end)
      |> assign_new(:unit, fn -> "/m" end)

    ~H"""
    <div
      class="relative flex flex-col h-full p-6 transition duration-500 ease-in-out bg-gray-200 rounded-lg dark:bg-gray-900 fade-in-animation"
    >
      <%= if @most_popular do %>
        <div class="absolute top-0 right-0 mr-6 -mt-4">
          <div
            class="inline-flex px-3 py-1 mt-px text-sm font-semibold text-green-600 bg-green-200 rounded-full"
          >
            Most Popular
          </div>
        </div>
      <% end %>

      <div
        class="pb-4 mb-4 transition duration-500 ease-in-out border-b border-gray-300 dark:border-gray-700"
      >
        <div
          class="mb-1 text-2xl font-bold leading-snug tracking-tight dark:text-primary-500 text-primary-600"
        >
          <%= @name %>
        </div>

        <div class="inline-flex items-baseline mb-2">
          <span class="text-2xl font-medium text-gray-600 dark:text-gray-400"><%= @currency %></span>
          <span
            class="text-3xl font-extrabold leading-tight text-gray-900 transition duration-500 ease-in-out dark:text-white"
          >
            <%= @price %>
          </span>
          <span class="font-medium text-gray-600 dark:text-gray-400"><%= @unit %></span>
        </div>

        <div class="text-gray-600 dark:text-gray-400">
          <%= @description %>
        </div>
      </div>

      <div class="mb-3 font-medium text-gray-700 dark:text-gray-200">
        Features include:
      </div>

      <ul class="-mb-3 text-gray-600 dark:text-gray-400 grow">
        <%= for feature <- @features do %>
          <li class="flex items-center mb-3">
            <Heroicons.Solid.check class="w-3 h-3 mr-3 text-green-500 fill-current shrink-0" />
            <span><%= feature %></span>
          </li>
        <% end %>
      </ul>

      <div class="p-3 mt-6 ">
        <.button link_type="a" to={@sign_up_path} class="w-full" label="Start free trial" />
      </div>
    </div>
    """
  end

  def footer(assigns) do
    assigns =
      assigns
      |> assign_new(:main_menu_items, fn -> [] end)

    ~H"""
    <section>
      <div class="py-20 bg-gray-900 radius-for-skewed">
        <div class="container px-4 mx-auto">
          <div class="flex flex-wrap items-center justify-between pb-12 border-b border-gray-800">
            <div class="w-full mb-12 lg:w-1/5 lg:mb-4">
              <a class="inline-block text-3xl font-bold leading-none" href="/">
                <.logo variant="light" />
              </a>
            </div>
            <div class="w-full lg:w-auto">
              <ul class="flex flex-wrap items-center lg:space-x-5">
                <.list_menu_items
                  li_class="w-full mb-2 md:w-auto md:mb-0"
                  a_class="text-gray-400 lg:text-sm hover:text-gray-300"
                  menu_items={@main_menu_items}
                />
              </ul>
            </div>
          </div>
          <div class="flex flex-wrap items-center justify-between mt-8">
            <p class="order-last text-sm text-gray-400">
              © <%= Timex.now().year %> <%= Application.get_env(:arslane_to_narnia, :business_name) %>
              . All rights reserved.
              <.link to="/privacy" label="Privacy Policy" class="pl-3 ml-3 border-l border-gray-500" />
              <.link to="/license" label="License" class="pl-3 ml-3 border-l border-gray-500" />
            </p>
            <div class="order-first mb-4 lg:mb-0 lg:order-last">
              <a
                target="_blank"
                class="inline-block p-2 mr-2 bg-gray-800 rounded hover:bg-gray-700 group"
                href="https://twitter.com/PetalFramework"
              >
                <svg
                  class="w-5 h-5 fill-gray-400 group-hover:fill-white"
                  xmlns="http://www.w3.org/2000/svg"
                  data-name="Layer 1"
                  viewBox="0 0 24 24"
                >
                  <path
                    d="M22,5.8a8.49,8.49,0,0,1-2.36.64,4.13,4.13,0,0,0,1.81-2.27,8.21,8.21,0,0,1-2.61,1,4.1,4.1,0,0,0-7,3.74A11.64,11.64,0,0,1,3.39,4.62a4.16,4.16,0,0,0-.55,2.07A4.09,4.09,0,0,0,4.66,10.1,4.05,4.05,0,0,1,2.8,9.59v.05a4.1,4.1,0,0,0,3.3,4A3.93,3.93,0,0,1,5,13.81a4.9,4.9,0,0,1-.77-.07,4.11,4.11,0,0,0,3.83,2.84A8.22,8.22,0,0,1,3,18.34a7.93,7.93,0,0,1-1-.06,11.57,11.57,0,0,0,6.29,1.85A11.59,11.59,0,0,0,20,8.45c0-.17,0-.35,0-.53A8.43,8.43,0,0,0,22,5.8Z"
                  />
                </svg>
              </a>
              <a
                target="_blank"
                class="inline-block p-2 mr-2 bg-gray-800 rounded hover:bg-gray-700 group"
                href="https://github.com/petalframework"
              >
                <svg
                  class="w-5 h-5 fill-gray-400 group-hover:fill-white"
                  xmlns="http://www.w3.org/2000/svg"
                  data-name="Layer 1"
                  viewBox="0 0 24 24"
                >
                  <path
                    d="M12,2.2467A10.00042,10.00042,0,0,0,8.83752,21.73419c.5.08752.6875-.21247.6875-.475,0-.23749-.01251-1.025-.01251-1.86249C7,19.85919,6.35,18.78423,6.15,18.22173A3.636,3.636,0,0,0,5.125,16.8092c-.35-.1875-.85-.65-.01251-.66248A2.00117,2.00117,0,0,1,6.65,17.17169a2.13742,2.13742,0,0,0,2.91248.825A2.10376,2.10376,0,0,1,10.2,16.65923c-2.225-.25-4.55-1.11254-4.55-4.9375a3.89187,3.89187,0,0,1,1.025-2.6875,3.59373,3.59373,0,0,1,.1-2.65s.83747-.26251,2.75,1.025a9.42747,9.42747,0,0,1,5,0c1.91248-1.3,2.75-1.025,2.75-1.025a3.59323,3.59323,0,0,1,.1,2.65,3.869,3.869,0,0,1,1.025,2.6875c0,3.83747-2.33752,4.6875-4.5625,4.9375a2.36814,2.36814,0,0,1,.675,1.85c0,1.33752-.01251,2.41248-.01251,2.75,0,.26251.1875.575.6875.475A10.0053,10.0053,0,0,0,12,2.2467Z"
                  />
                </svg>
              </a>
            </div>
          </div>
        </div>
      </div>
    </section>
    """
  end

  def javascript(assigns) do
    ~H"""
    <!-- Slideshow scroller library -->
    <link rel="stylesheet" href="https://unpkg.com/flickity@2/dist/flickity.min.css" />

    <script type="module">
      // Use GSAP for animations
      // https://greensock.com/gsap/
      import gsap from 'https://cdn.skypack.dev/gsap';

      // Put it on the window for when you want to try out animations in the console
      window.gsap = gsap;

      // A plugin for GSAP that detects when an element enters the viewport - this helps with timing the animation
      import ScrollTrigger from "https://cdn.skypack.dev/gsap/ScrollTrigger";
      gsap.registerPlugin(ScrollTrigger);

      // Flickity allows for a touch-enabled slideshow - used for testimonials
      import flickity from 'https://cdn.skypack.dev/flickity@2';

      // When you scroll down, you will notice the navbar becomes translucent.
      window.addEventListener("scroll", makeHeaderTranslucentOnScroll);

      animateHero();
      setupPageAnimations();
      setupFlickity();

      // This is needed to ensure the animations timings are correct as you scroll
      setTimeout(() => {
        ScrollTrigger.refresh(true);
      }, 1000);

      function makeHeaderTranslucentOnScroll() {
        const header = document.querySelector("header");
        if (header) {
          const distanceFromTop = window.scrollY;
          distanceFromTop > 0
            ? header.classList.add("is-active")
            : header.classList.remove("is-active");
        }
      }

      function animateHero() {

        // A timeline just means you can chain animations together - one after another
        // https://greensock.com/docs/v3/GSAP/gsap.timeline()
        const heroTimeline = gsap.timeline({});

        heroTimeline
          .to("#hero .fade-in-animation", {
            opacity: 1,
            y: 0,
            stagger: 0.1,
            ease: "power2.out",
            duration: 1,
          })
          .to("#hero-image", {
            opacity: 1,
            x: 0,
            duration: 0.4
          }, ">-1.3")
          .to("#logo-cloud .fade-in-animation", {
            opacity: 1,
            y: 0,
            stagger: 0.1,
            ease: "power2.out",
          })
      }

      function setupPageAnimations() {

        // This allows us to give any individual HTML element the class "solo-animation"
        // and that element will fade in when scrolled into view
        gsap.utils.toArray(".solo-animation").forEach((item) => {
          gsap.to(item, {
            y: 0,
            opacity: 1,
            duration: 0.5,
            ease: "power2.out",
            scrollTrigger: {
              trigger: item,
            },
          });
        });

        // Add the class "stagger-fade-in-animation" to a parent element, then all elements within it
        // with the class "fade-in-animation" will fade in on scroll in a staggered formation to look
        // more natural than them all fading in at once
        gsap.utils.toArray(".stagger-fade-in-animation").forEach((stagger) => {
          const children = stagger.querySelectorAll(".fade-in-animation");
          gsap.to(children, {
            opacity: 1,
            y: 0,
            ease: "power2.out",
            stagger: 0.15,
            duration: 0.5,
            scrollTrigger: {
              trigger: stagger,
              start: "top 75%",
            },
          });
        });
      }

      function setupFlickity() {
        let el = document.querySelector(".flickity");

        if(el){
          new flickity(el, {
            cellAlign: "left",
            prevNextButtons: false,
            adaptiveHeight: false,
            cellSelector: ".carousel-cell",
          });
        }
      }
    </script>
    """
  end

  @doc """
  To make the landing page stand out, we have added some effects that can't be achieved with Tailwind alone.
  Hence you will need to include this component at the top of your page for everything to work.
  You could add this to your app.css file if you like (we put it here to keep the app.css file clean).
  """
  def css(assigns) do
    ~H"""
    <style>
      /* Hover effects for the top menu */
      header .menu-item {
        position: relative;
      }

      header .menu-item:before {
        content: '';
        position: absolute;
        right: 0;
        width: 0;
        bottom: 0;
        height: 2px;
        background: #4b5563;
        transition: 0.3s all ease;
      }

      .dark header .menu-item:before {
        background: #ccc;
      }

      header .menu-item:hover:before {
        left: 0;
        width: 100%;
      }

      header .menu-item.is-active:before {
        left: 0;
        width: 100%;
      }

      /* Translucent effects for the the navbar when you scroll down the page */
      header.is-active {
        background: rgba(255, 255, 255, .55);
        @apply shadow;
      }

      .dark header.is-active {
        background: rgba(0,0,0,.45);
        @apply shadow;
      }

      .semi-translucent {
        backdrop-filter: saturate(180%) blur(10px);
        -webkit-backdrop-filter: saturate(180%) blur(10px);
        -moz-backdrop-filter: saturate(180%) blur(10px);
      }

      /* Animation effects (works in combination with the GSAP Javascript library) */
      /* Basically the CSS describes how the element starts (opacity: 0), and GSAP animates it back to normal (opacity: 1) */
      .fade-in-animation {
        opacity: 0;
        transform: translateY(15px);
      }

      .fade-in-from-right-animation {
        opacity: 0;
        transform: translateX(30px);
      }

      .scale-in {
        transform: scale(0);
      }

      /* Modify the testimonial slider to go off the page */
      #testimonials .flickity-viewport {
        overflow: unset;
      }

      #testimonials .flickity-page-dots {
        position: relative;
        bottom: unset;
        margin-top: 40px;
        text-align: center;
      }

      #testimonials .flickity-page-dots .dot {
        background: #3b82f6;
        transition: 0.3s all ease;
        opacity: 0.35;
        margin: 0;
        margin-right: 10px;
      }

      #testimonials .flickity-page-dots .dot.is-selected {
        opacity: 1;
      }

      .dark #testimonials .flickity-page-dots .dot {
        background: white;
      }
    </style>
    """
  end

  def render_pricing_feature(assigns) do
    assigns =
      assigns
      |> assign_new(:icon_class, fn -> "" end)

    ~H"""
    <li class="flex items-center w-full py-2 fade-in-animation">
      <svg
        class={"#{@icon_class} flex-shrink-0 mr-3"}
        width="16"
        height="16"
        xmlns="http://www.w3.org/2000/svg"
      >
        <path
          d="M8 0a8 8 0 100 16A8 8 0 008 0zm4.471 6.471l-5.04 5.04a.666.666 0 01-.942 0L4.187 9.21a.666.666 0 11.942-.942l1.831 1.83 4.569-4.568a.666.666 0 11.942.942z"
          fill="#FFF"
          class="fill-current"
          fill-rule="nonzero"
        />
      </svg>

      <div class="text-left"><%= @text %></div>
    </li>
    """
  end
end
