use Rack::Static,
  urls: ['/images', '/js', '/css'],
  root: 'dist'

run lambda { |_env|
  [
    200,
    {
      'Content-Type'  => 'text/html',
      'Cache-Control' => 'public, max-age=86400',
    },
    File.open('dist/html/bro.html', File::RDONLY),
  ]
}
