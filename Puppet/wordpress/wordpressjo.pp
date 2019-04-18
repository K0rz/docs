class wordpressjo {
wordpress_app::simple { 'all_in_one':
  nodes => {
    Node['client2.jojounette.fr'] => [
      Wordpress_app::Database['all_in_one'],
      Wordpress_app::Web['all_in_one'],
    ]
  }
}
}
