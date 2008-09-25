module HasPermalink
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def has_permalink(*attrs)
      options = attrs.extract_options!

      param_attr = options[:param] || attrs.first
      param_attr = param_attr.to_s if param_attr

      attrs.each do |attr|
        title_attr = attr.to_s
        link_attr = "#{attr}_permalink"

        before_validation "update_#{link_attr}"

        validates_presence_of title_attr, link_attr
        validates_format_of link_attr, :with => /^[A-Za-z0-9_-]+$/
        validates_uniqueness_of link_attr

        self.class_eval "def update_#{link_attr};self.#{link_attr}=#{title_attr} if #{link_attr}.blank?;self.#{link_attr}=#{link_attr}.gsub(/[^A-Za-z0-9_-]+/,'-').gsub(/^-|-$/,'').downcase;end"
        self.class_eval "def to_param;#{link_attr};end" if title_attr == param_attr
      end
    end
  end
end