module CommentsHelper
  def resource_name(resource)
    resource.class.name.downcase
  end
end
