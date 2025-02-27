class PreviewEventFluffService
  def self.get_initial_activities
    activities = {"activities"=>[{"title"=>"Easter Egg Hunt", "description"=>"Children search for hidden Easter eggs around the event area.", "step_by_step"=>["Hide Easter eggs around the venue", "Explain the rules to the children", "Guide children to start searching", "Encourage all participants to find eggs", "Conclude the hunt and distribute small prizes"], "materials"=>["Plastic eggs", "Small prizes or candy"], "genre"=>"Adventure", "age"=>3}, {"title"=>"Easter Bunny Dance", "description"=>"An energetic dance session led by an instructor dressed as the Easter Bunny.", "step_by_step"=>["Gather the children around the dance area", "Introduce the Easter Bunny and demonstrate simple dance moves", "Play lively Easter-themed music", "Encourage children to follow along with the Bunny", "Conclude with a fun dance-off and clapping session"], "materials"=>["Easter Bunny costume", "Speakers", "Easter-themed music"], "genre"=>"Dance", "age"=>4}, {"title"=>"Easter Crafting", "description"=>"A hands-on crafting activity where children create Easter decorations.", "step_by_step"=>["Provide each child with a crafting kit", "Guide them through making an Easter basket", "Allow time to decorate the baskets with stickers and colors", "Assist as needed", "Display all the crafted items for everyone to see"], "materials"=>["Craft paper", "Markers", "Stickers", "Glue", "Safety scissors"], "genre"=>"Art", "age"=>5}, {"title"=>"Storytime with Easter Tales", "description"=>"A storytelling session featuring Easter-themed tales.", "step_by_step"=>["Set up a comfortable seating area", "Choose a couple of Easter-themed picture books", "Read the stories aloud to the children", "Engage children by asking questions", "Conclude with a group discussion on their favorite parts"], "materials"=>["Easter-themed picture books"], "genre"=>"Storytelling", "age"=>3}, {"title"=>"Easter Egg Roll Race", "description"=>"A fun race where children roll eggs across the floor.", "step_by_step"=>["Set up a starting line and a finish line", "Provide each child with a plastic egg and a spoon", "Instruct them on rolling the egg with the spoon", "Start the race with a simple start signal", "Cheer on the participants and celebrate everyone's efforts"], "materials"=>["Plastic eggs", "Plastic spoons", "Markers for lines"], "genre"=>"Games", "age"=>6}]}

    activities = activities["activities"].map do |activity_data|
      title = activity_data["title"] || "Untitled"
      description = activity_data["description"] || "No description available."
      step_by_step = activity_data["step_by_step"] || []
      materials = activity_data["materials"] || []
      genre = activity_data["genre"] || "General"
      age = activity_data["age"] || 0

      # Construct full description
      full_description = <<~DESC
        **Description**: #{description}

        **Step-by-Step Instructions**:
        #{step_by_step.map.with_index(1) { |step, i| "#{i}. #{step}" }.join("\n")}

        **Materials**: #{materials.join(', ')}
      DESC

      Activity.new(
        title: title,
        description: full_description,
        age: age.to_i,
        genres: [genre] # Convert to an array
      )
    end
    return activities
  end

  def self.get_saved_activities
    activities = {"activities"=>[
      {"title"=>"Easter Egg Hunt", "description"=>"Children search for hidden Easter eggs around the event area.", "step_by_step"=>["Hide Easter eggs around the venue", "Explain the rules to the children", "Guide children to start searching", "Encourage all participants to find eggs", "Conclude the hunt and distribute small prizes"], "materials"=>["Plastic eggs", "Small prizes or candy"], "genre"=>"Adventure", "age"=>3},
      {"title"=>"Easter Crafting", "description"=>"A hands-on crafting activity where children create Easter decorations.", "step_by_step"=>["Provide each child with a crafting kit", "Guide them through making an Easter basket", "Allow time to decorate the baskets with stickers and colors", "Assist as needed", "Display all the crafted items for everyone to see"], "materials"=>["Craft paper", "Markers", "Stickers", "Glue", "Safety scissors"], "genre"=>"Art", "age"=>5},
      {"title"=>"Easter Egg Roll Race", "description"=>"A fun race where children roll eggs across the floor.", "step_by_step"=>["Set up a starting line and a finish line", "Provide each child with a plastic egg and a spoon", "Instruct them on rolling the egg with the spoon", "Start the race with a simple start signal", "Cheer on the participants and celebrate everyone's efforts"], "materials"=>["Plastic eggs", "Plastic spoons", "Markers for lines"], "genre"=>"Games", "age"=>6}]}

    activities = activities["activities"].map do |activity_data|
      title = activity_data["title"] || "Untitled"
      description = activity_data["description"] || "No description available."
      step_by_step = activity_data["step_by_step"] || []
      materials = activity_data["materials"] || []
      genre = activity_data["genre"] || "General"
      age = activity_data["age"] || 0

      # Construct full description
      full_description = <<~DESC
        **Description**: #{description}

        **Step-by-Step Instructions**:
        #{step_by_step.map.with_index(1) { |step, i| "#{i}. #{step}" }.join("\n")}

        **Materials**: #{materials.join(', ')}
      DESC

      Activity.new(
        title: title,
        description: full_description,
        age: age.to_i,
        genres: [genre] # Convert to an array
      )
    end

    return activities
  end

  def self.get_regenerated_activities
    activities = {"activities"=>[
      {"title"=>"Easter Egg Decorating", "description"=>"A creative activity where kids decorate eggs with various craft supplies.", "step_by_step"=>["Boil the eggs in advance", "Set up a decorating station", "Introduce the decorating tools and supplies", "Assist the kids as needed while they decorate"], "materials"=>["Hard-boiled eggs", "Markers", "Stickers", "Glue", "Glitter"], "genre"=>"Arts & Crafts", "age"=>3},
      {"title"=>"Musical Bunny Ears", "description"=>"A fun twist on musical chairs involving bunny ears.", "step_by_step"=>["Place bunny ears in a circle on the ground", "Play Easter-themed music", "Have kids walk around the circle", "Stop the music and have kids grab ears to wear"], "materials"=>["Bunny ears", "Music player"], "genre"=>"Music & Movement", "age"=>3},
      {"title"=>"Easter Parade", "description"=>"Kids dress in Easter-themed costumes and parade around the venue.", "step_by_step"=>["Provide various costume accessories", "Enable each child to choose and dress up", "Organize them into a simple parade line", "Lead them on a short parade around the venue"], "materials"=>["Costume accessories", "Bunny ears", "Easter hats"], "genre"=>"Drama", "age"=>5},
      {"title"=>"Egg Toss Game", "description"=>"A fun practice in precision where kids toss eggs into baskets.", "step_by_step"=>["Set up baskets at varying distances", "Explain how to toss the eggs", "Give each child multiple tries to land in a basket", "Encourage and assist them as needed"], "materials"=>["Plastic eggs", "Baskets"], "genre"=>"Physical Play", "age"=>4},
      {"title"=>"Easter Sing-Along", "description"=>"An engaging session of singing Easter and spring-themed songs.", "step_by_step"=>["Prepare a playlist of Easter-themed songs", "Encourage participation in singing", "Use simple musical instruments for best interaction", "Guide kids through different songs"], "materials"=>["Song lyrics sheets", "Musical instruments like tambourines"], "genre"=>"Music & Movement", "age"=>3},
      {"title"=>"Easter Bunny Dance", "description"=>"An energetic dance session led by an instructor dressed as the Easter Bunny.", "step_by_step"=>["Gather the children around the dance area", "Introduce the Easter Bunny and demonstrate simple dance moves", "Play lively Easter-themed music", "Encourage children to follow along with the Bunny", "Conclude with a fun dance-off and clapping session"], "materials"=>["Easter Bunny costume", "Speakers", "Easter-themed music"], "genre"=>"Dance", "age"=>4},
      ]}

    activities = activities["activities"].sample(2)

    activities = activities.map do |activity_data|
      title = activity_data["title"] || "Untitled"
      description = activity_data["description"] || "No description available."
      step_by_step = activity_data["step_by_step"] || []
      materials = activity_data["materials"] || []
      genre = activity_data["genre"] || "General"
      age = activity_data["age"] || 0

      # Construct full description
      full_description = <<~DESC
        **Description**: #{description}

        **Step-by-Step Instructions**:
        #{step_by_step.map.with_index(1) { |step, i| "#{i}. #{step}" }.join("\n")}

        **Materials**: #{materials.join(', ')}
      DESC

      Activity.new(
        title: title,
        description: full_description,
        age: age.to_i,
        genres: [genre] # Convert to an array
      )
    end

    return activities
  end
end
