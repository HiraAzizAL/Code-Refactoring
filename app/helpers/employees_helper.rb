module EmployeesHelper
  def paginate_links(meta)
    return unless meta

    first_page = employees_path(page: 1)
    next_page = employees_path(page: meta["next_page"])
    prev_page = employees_path(page: meta["prev_page"])
    last_page = employees_path(page: meta["total_pages"])

    links = [
      link_to('First Page', first_page),
      link_to('Next Page', next_page),
      link_to('Previous Page', prev_page),
      link_to('Last Page', last_page)
    ].join(' | ').html_safe

    content_tag(:div, links, class: "pagination-links")
  end
end
