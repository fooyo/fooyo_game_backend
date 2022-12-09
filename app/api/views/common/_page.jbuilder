json.total_count  objects.total_count  if objects.respond_to?(:total_count)
json.total_pages  objects.total_pages  if objects.respond_to?(:total_pages)
json.current_page objects.current_page if objects.respond_to?(:current_page)
json.next_page    objects.next_page    if objects.respond_to?(:next_page)