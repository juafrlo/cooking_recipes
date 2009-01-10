module RecetasHelper
  def add_step_link(name)
    link_to_function name do |page| 
  			page.insert_html :bottom, :steps, :partial => 'step', :object => Step.new
  	end
  end
end
