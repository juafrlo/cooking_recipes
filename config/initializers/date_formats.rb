ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
	:date => '%d/%m/%Y %H:%M',
	:date_time12  => "%m/%d/%Y %I:%M%p",
	:date_time24  => "%m/%d/%Y %H:%M"
)