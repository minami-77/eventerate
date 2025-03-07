class PreviewEventFluffService
  def self.get_initial_activities
    activities = {
      "activities"=>[
        {"title"=>"Easter Bunny Dance", "description"=>"An energetic dance session led by an instructor dressed as the Easter Bunny.", "instructions"=>["Gather the children around the dance area", "Introduce the Easter Bunny and demonstrate simple dance moves", "Play lively Easter-themed music", "Encourage children to follow along with the Bunny", "Conclude with a fun dance-off and clapping session"], "materials"=>["Easter Bunny costume", "Speakers", "Easter-themed music"], "genre"=>"Dance", "age"=>4},
        {"title"=>"Easter Crafting", "description"=>"A hands-on crafting activity where children create Easter decorations.", "instructions"=>["Provide each child with a crafting kit", "Guide them through making an Easter basket", "Allow time to decorate the baskets with stickers and colors", "Assist as needed", "Display all the crafted items for everyone to see"], "materials"=>["Craft paper", "Markers", "Stickers", "Glue", "Safety scissors"], "genre"=>"Art", "age"=>5},
        {"title"=>"Easter Egg Roll Race", "description"=>"A fun race where children roll eggs across the floor.", "instructions"=>["Set up a starting line and a finish line", "Provide each child with a plastic egg and a spoon", "Instruct them on rolling the egg with the spoon", "Start the race with a simple start signal", "Cheer on the participants and celebrate everyone's efforts"], "materials"=>["Plastic eggs", "Plastic spoons", "Markers for lines"], "genre"=>"Games", "age"=>6}]}

    activities = activities["activities"].map do |activity_data|
      {
        "title" => activity_data["title"] || "Untitled",
        "description" => activity_data["description"] || "No description available.",
        "instructions" => activity_data["instructions"] || [],
        "materials" => activity_data["materials"] || [],
        "age" => activity_data["age"] || 0,
      }
    end
    return activities
  end

  def self.get_saved_activities
    activities = {"activities"=>[
      {"title"=>"Easter Egg Hunt", "description"=>"Children search for hidden Easter eggs around the event area.", "instructions"=>["Hide Easter eggs around the venue", "Explain the rules to the children", "Guide children to start searching", "Encourage all participants to find eggs", "Conclude the hunt and distribute small prizes"], "materials"=>["Plastic eggs", "Small prizes or candy"], "genre"=>"Adventure", "age"=>3},
      {"title"=>"Easter Crafting", "description"=>"A hands-on crafting activity where children create Easter decorations.", "instructions"=>["Provide each child with a crafting kit", "Guide them through making an Easter basket", "Allow time to decorate the baskets with stickers and colors", "Assist as needed", "Display all the crafted items for everyone to see"], "materials"=>["Craft paper", "Markers", "Stickers", "Glue", "Safety scissors"], "genre"=>"Art", "age"=>5},
      {"title"=>"Easter Egg Roll Race", "description"=>"A fun race where children roll eggs across the floor.", "instructions"=>["Set up a starting line and a finish line", "Provide each child with a plastic egg and a spoon", "Instruct them on rolling the egg with the spoon", "Start the race with a simple start signal", "Cheer on the participants and celebrate everyone's efforts"], "materials"=>["Plastic eggs", "Plastic spoons", "Markers for lines"], "genre"=>"Games", "age"=>6}]}

    activities = activities["activities"].map do |activity_data|
      {
        "title" => activity_data["title"] || "Untitled",
        "description" => activity_data["description"] || "No description available.",
        "instructions" => activity_data["instructions"] || [],
        "materials" => activity_data["materials"] || [],
        "age" => activity_data["age"] || 0,
      }
    end

    return activities
  end

  def self.get_regenerated_activities
    activities = {"activities"=>[
      {"title"=>"Easter Egg Decorating", "description"=>"A creative activity where kids decorate eggs with various craft supplies.", "instructions"=>["Boil the eggs in advance", "Set up a decorating station", "Introduce the decorating tools and supplies", "Assist the kids as needed while they decorate"], "materials"=>["Hard-boiled eggs", "Markers", "Stickers", "Glue", "Glitter"], "genre"=>"Arts & Crafts", "age"=>3},
      {"title"=>"Musical Bunny Ears", "description"=>"A fun twist on musical chairs involving bunny ears.", "instructions"=>["Place bunny ears in a circle on the ground", "Play Easter-themed music", "Have kids walk around the circle", "Stop the music and have kids grab ears to wear"], "materials"=>["Bunny ears", "Music player"], "genre"=>"Music & Movement", "age"=>3},
      {"title"=>"Easter Parade", "description"=>"Kids dress in Easter-themed costumes and parade around the venue.", "instructions"=>["Provide various costume accessories", "Enable each child to choose and dress up", "Organize them into a simple parade line", "Lead them on a short parade around the venue"], "materials"=>["Costume accessories", "Bunny ears", "Easter hats"], "genre"=>"Drama", "age"=>5},
      {"title"=>"Egg Toss Game", "description"=>"A fun practice in precision where kids toss eggs into baskets.", "instructions"=>["Set up baskets at varying distances", "Explain how to toss the eggs", "Give each child multiple tries to land in a basket", "Encourage and assist them as needed"], "materials"=>["Plastic eggs", "Baskets"], "genre"=>"Physical Play", "age"=>4},
      {"title"=>"Easter Sing-Along", "description"=>"An engaging session of singing Easter and spring-themed songs.", "instructions"=>["Prepare a playlist of Easter-themed songs", "Encourage participation in singing", "Use simple musical instruments for best interaction", "Guide kids through different songs"], "materials"=>["Song lyrics sheets", "Musical instruments like tambourines"], "genre"=>"Music & Movement", "age"=>3},
      {"title"=>"Easter Bunny Dance", "description"=>"An energetic dance session led by an instructor dressed as the Easter Bunny.", "instructions"=>["Gather the children around the dance area", "Introduce the Easter Bunny and demonstrate simple dance moves", "Play lively Easter-themed music", "Encourage children to follow along with the Bunny", "Conclude with a fun dance-off and clapping session"], "materials"=>["Easter Bunny costume", "Speakers", "Easter-themed music"], "genre"=>"Dance", "age"=>4},
      ]}

    activities = activities["activities"].sample(2)

    activities = activities.map do |activity_data|
      {
        "title" => activity_data["title"] || "Untitled",
        "description" => activity_data["description"] || "No description available.",
        "instructions" => activity_data["instructions"] || [],
        "materials" => activity_data["materials"] || [],
        "age" => activity_data["age"] || 0,
      }
    end

    return activities
  end

  def self.get_initial_tasks
    return {
        "Easter Egg Hunt" => [
          "Plan venue layout and gather materials (eggs, prizes)",
          "Assign staff for setup and supervision",
          "Hide eggs and prepare gathering area",
          "Explain rules, start hunt, and distribute prizes"
        ],
        "Easter Bunny Dance" => [
          "Prepare dance area, sound system, and playlist",
          "Ensure Easter Bunny costume is ready",
          "Lead children in dance activities",
          "Wrap up with a fun dance-off and group photo"
        ],
        "Easter Crafting" => [
          "Gather and organize crafting supplies",
          "Set up tables with enough space for participants",
          "Guide children through crafting activities",
          "Display finished crafts and assist with cleanup"
        ],
        "Storytime with Easter Tales" => [
          "Select and review Easter-themed books",
          "Arrange a cozy seating area",
          "Read stories and engage children with questions",
          "Wrap up with a group discussion"
        ],
        "Easter Egg Roll Race" => [
          "Mark race track and prepare materials (eggs, spoons)",
          "Explain race rules to participants",
          "Supervise race and ensure fair play",
          "Celebrate participation and hand out small rewards"
        ]
      }
  end

  def self.get_saved_tasks
    return {
        "Easter Egg Hunt" => [
          "Plan venue layout and gather materials (eggs, prizes)",
          "Assign staff for setup and supervision",
          "Hide eggs and prepare gathering area",
          "Explain rules, start hunt, and distribute prizes"
        ],
        "Easter Crafting" => [
          "Gather and organize crafting supplies",
          "Set up tables with enough space for participants",
          "Guide children through crafting activities",
          "Display finished crafts and assist with cleanup"
        ],
        "Easter Egg Roll Race" => [
          "Mark race track and prepare materials (eggs, spoons)",
          "Explain race rules to participants",
          "Supervise race and ensure fair play",
          "Celebrate participation and hand out small rewards"
        ]
      }
  end

  def self.get_regenerated_tasks
    return {
      "Easter Egg Decorating" => [
        "Boil eggs in advance and gather decorating materials",
        "Set up a decorating station with markers, stickers, and glitter",
        "Introduce decorating tools to the kids",
        "Assist children as they decorate their eggs"
      ],
      "Musical Bunny Ears" => [
        "Place bunny ears in a circle on the ground",
        "Prepare Easter-themed music and music player",
        "Guide children to walk around the circle while music plays",
        "Stop the music and have children grab bunny ears"
      ],
      "Easter Parade" => [
        "Provide costume accessories like bunny ears and Easter hats",
        "Help children dress up in their chosen costumes",
        "Organize children into a parade line",
        "Lead the parade around the venue"
      ],
      "Egg Toss Game" => [
        "Set up baskets at various distances",
        "Explain how to toss eggs into the baskets",
        "Give each child multiple tries to land eggs in the baskets",
        "Encourage children and provide assistance if needed"
      ],
      "Easter Sing-Along" => [
        "Prepare a playlist of Easter and spring songs",
        "Encourage children to participate in singing",
        "Provide tambourines or simple instruments for interaction",
        "Guide children through the songs with fun movements"
      ],
      "Easter Bunny Dance" => [
        "Gather children around the dance area and set up music",
        "Dress the instructor in the Easter Bunny costume",
        "Play lively Easter-themed music and demonstrate dance moves",
        "Encourage kids to follow the dance moves and conclude with a dance-off"
      ]
    }
  end
end
