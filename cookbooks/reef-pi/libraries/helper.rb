module ReefPiHelper
  def pi_zero?
    return node['kernel']['machine'] == 'armv6l'
  end

  def installer_url
     prefix = 'https://github.com/reef-pi/reef-pi/releases/download/'
     pi = pi_zero? ? '0' : '3'
     return prefix + node['reef_pi']['version'] + '/reef-pi-' + node['reef_pi']['version'] + '-pi' + pi + '.deb'
  end

  def installer_name
     pi = pi_zero? ? '0' : '3'
     return 'reef-pi-' + node['reef_pi']['version'] + '-pi' + pi + '.deb'
  end
end
