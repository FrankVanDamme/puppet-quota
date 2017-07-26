Puppet::Type.type(:quota).provide(:quota) do
  desc 'Sets the quota on any given user(id) or group(id)'

  commands :setquota => 'quotatool'
  commands :repquota => 'quota'

  def create
    if @resource[:block_soft_limit].to_i > @resource[:block_hard_limit].to_i
      @resource[:block_soft_limit] = @resource[:block_hard_limit]
    end

    setquota('-u', "#{@resource[:name]}", '-b', '-q', "#{@resource[:block_soft_limit]}", '-l',
             "#{@resource[:block_hard_limit]}", "#{@resource[:filesystem]}")

    if @resource[:inode_soft_limit].to_i > @resource[:inode_hard_limit].to_i
      @resource[:inode_soft_limit] = @resource[:inode_hard_limit]
    end

    setquota('-u', "#{@resource[:name]}", '-i', '-q', "#{@resource[:inode_soft_limit]}", '-l',
             "#{@resource[:inode_hard_limit]}", "#{@resource[:filesystem]}")
  end

  def destroy
    setquota('-u', "#{@resource[:name]}", '-b', '-q', 0, '-l', 0, "#{@resource[:filesystem]}")
    setquota('-u', "#{@resource[:name]}", '-i', '-q', 0, '-l', 0, "#{@resource[:filesystem]}")
  end

  def exists?
    cmd = [command(:repquota), '--show-mntpoint', '--hide-device', '-p', '-w', '-u', "#{@resource[:name]}"].join(' ')
    out = execute(cmd, {:failonfail => true, :override_locale => true, :squelch => false, :combine => true})

    if out.include? 'none'
      return false
    else
      lines = out.split("\n")

      # Remove two header lines
      lines.drop(2)

      # Iterate filesystems with quota
      lines.each do |line|
        if line.split(' ').length == 9
          parts = lines[2].split(' ')
          filesystem = parts[0].strip

          # Get the quota of the user for the correct filesystem
          if filesystem != @resource[:filesystem]
            next
          end

          block_soft_limit = parts[2].strip.to_i
          block_hard_limit = parts[3].strip.to_i
          inode_soft_limit = parts[6].strip.to_i
          inode_hard_limit = parts[7].strip.to_i

          if block_soft_limit != @resource[:block_soft_limit].to_i ||
              block_hard_limit != @resource[:block_hard_limit].to_i ||
              inode_soft_limit != @resource[:inode_soft_limit].to_i ||
              inode_hard_limit != @resource[:inode_hard_limit].to_i

            return false
          end
        end
      end

      return true
    end
  end
end
