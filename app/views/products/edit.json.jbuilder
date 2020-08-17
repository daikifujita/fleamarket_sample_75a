json.array! @pictures do |picture|
  json.id picture.id
  json.image picture.image.url
end