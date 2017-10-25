class Bug < ApplicationRecord
  after_create do
    logger.info "Bug##{id} was successfully created."
  end

  after_update do
    logger.info "Bug##{id} was successfully updated."
  end
  
end
