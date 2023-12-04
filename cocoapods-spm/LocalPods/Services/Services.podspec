Pod::CompactSpec.new do |s|
	s.name = "Services"

  s.spm_dependency(
    url: "https://github.com/trinhngocthuyen/orcam.git",
    requirement: {
      kind: "branch",
      branch: "main",
    },
    products: ["Orcam"]
  )
end
