require "./lib/gdrive/api"

module GDrive
  module FS
    def self.all_files
      @all_files ||= GDrive::API.list_files
    end

    def self.get_file id:
      all_files.find { |file| file.id == id }
    end

    def self.parent_files_ids file
      file.parents || []
    end

    def self.file_children file
      all_files.select { |f| parent_files_ids(f).include? file.id }
    end

    def self.folder? file
      file.mime_type == "application/vnd.google-apps.folder"
    end

    def self.tree root_file:
      {
        file: root_file,
        children: file_children(root_file).map do |child_file|
          tree root_file: child_file
        end,
      }
    end
  end
end
