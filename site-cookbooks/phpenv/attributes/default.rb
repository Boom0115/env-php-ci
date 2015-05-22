# Nginxのドキュメントルートのオーナー
default['nginx']['docroot']['owner'] = 'root'

# Nginxのドキュメントルートのグループ
default['nginx']['docroot']['group'] = 'root'

# Nginxのドキュメントルートのパス
default['nginx']['docroot']['path'] = "/usr/share/nginx/html"

# Nginxのドキュメントルートが無いときに作成するか？
default['nginx']['docroot']['force_create'] = false

# Nginxのdefaultサイトに引き渡すパラメータ
default['nginx']['default']['fastcgi_params'] = []

# Nginxでテスト用のバーチャルホストを使うかどうか
default['nginx']['test']['available'] = false

# Nginxのtestサイトに引き渡すパラメータ
default['nginx']['test']['fastcgi_params'] = []

# MySQLのルートパスワード
default['mysql']['root_password'] = 'password'
