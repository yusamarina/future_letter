module ApplicationHelper
  def default_meta_tags
    {
      site: 'FUTURE LETTER',
      title: 'FUTURE LETTER',
      reverse: true,
      separator: '|',
      description: 'サプライズでお手紙を送るサービスです。',
      keywords: '手紙',
      canonical: request.original_url,
      noindex: ! Rails.env.production?,
      icon: [
        { href: image_url('favicon.ico') },
        { href: image_url('icon_180.jpg'), rel: 'apple-touch-icon', sizes: '180x180', type: 'image/jpg' },
      ],
      og: {
        site_name: 'FUTURE LETTER',
        title: 'FUTURE LETTER',
        description: 'サプライズでお手紙を送るサービスです。',
        type: 'website',
        url: request.original_url,
        image: image_url('ogp_630.jpg'),
        locale: 'ja_JP',
      },
      twitter: {
        card: 'summary_large_image',
        site: '@FUTURE_LETTER_',
      }
    }
  end
end
