<div class="navbar navbar-default">
  <div class="navbar-header">
    <%= link_to "WCC", welcome_index_path, class: "navbar-brand" %>
  </div>
</div>

<%= render partial: 'shared/notices' %>

<div class="panel panel-default">
  <div class="panel-heading">
    <h4 class="panel-title">Winery Manager Login</h4>
  </div>
  <div class="panel-body">
    <%= form_for(resource, as: resource_name, url: session_path(resource_name)) do |f| %>
      <div class="form-group form-group-lg">
        <%= f.email_field :email, autofocus: true, class: "form-control", placeholder: "Email" %>
      </div>
      <div class="form-group form-group-lg">
        <%= f.password_field :password, autocomplete: "off", class: "form-control", placeholder: "Password" %>
      </div>
      <% if devise_mapping.rememberable? -%>
        <div class="form-group form-group-lg">
          <%= f.check_box :remember_me %>
          <%= f.label :remember_me %>
        </div>
      <% end -%>
      <div class="form-group form-group-lg">
        <%= f.submit "Log in", class: "btn btn-primary btn-lg" %>
      </div>
    <% end %>
  </div>
</div>
