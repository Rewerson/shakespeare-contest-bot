class QuizController < ApplicationController
  def solver
    render status: 200
    answer = nil

    case params['level'].to_i
    when 1
      question = params[:question]
      $data_1.each do |key, value|
        value.each do |string|
          if string == question
            answer = key
            break
          end
        end
      end
    when 2
      question = params[:question].gsub(/[^[:alnum:]['-][:space:]]/, '').split(' ')
      $data_2345.each do |string|
        if question - string == ['WORD']
          next if (string - question).size != 1
          answer = string - question
          break
        end
      end
    when 3
      question1 = (params[:question].split("\n"))[0].gsub(/[^[:alnum:]['-][:space:]]/, '').split(' ')
      question2 = (params[:question].split("\n"))[1].gsub(/[^[:alnum:]['-][:space:]]/, '').split(' ')
      $data_2345.each_with_index do |string, index|
        if question1 - string == ['WORD']
          next if ((string - question1).size != 1) || (($data_2345[index+1] - question2).size != 1)
          answer = "#{string - question1},#{$data_2345[index+1] - question2}"
          break
        end
      end
    when 4
      question1 = (params[:question].split("\n"))[0].gsub(/[^[:alnum:]['-][:space:]]/, '').split(' ')
      question2 = (params[:question].split("\n"))[1].gsub(/[^[:alnum:]['-][:space:]]/, '').split(' ')
      question3 = (params[:question].split("\n"))[2].gsub(/[^[:alnum:]['-][:space:]]/, '').split(' ')
      $data_2345.each_with_index do |string, index|
        if question1 - string == ['WORD']
          next if ((string - question1).size != 1) || (($data_2345[index+1] - question2).size != 1)
          answer = "#{string - question1},#{$data_2345[index+1] - question2},#{$data_2345[index+2] - question3}"
          break
        end
      end
    when 5
      question = params[:question].gsub(/[^[:alnum:]['-][:space:]]/, '').split(' ')
      $data_2345.each do |string|
        if (question - string).size == 1
          answer = "#{string - question},#{question - string}"
          break
        end
      end
    when 6, 7
      question = params[:question].gsub(/[^[:alnum:]['-][:space:]]/, '').chars.sort.join
      $data_67.each do |key, value|
        if value == question
          answer = key
          break
        end
      end
    when 8
      question = params[:question].gsub(/[^[:alnum:][ ]]/, '').chars.sort.join
      $data_8.each do |key, value|
        if value.length == question.length && value.scan(/\ /) == question.scan(/\ /) && value.scan(/[A-Z]/) == question.scan(/[A-Z]/)
          qcu = question.chars.uniq
          vcu = value.chars.uniq
          if (qcu - vcu).size <= 1 && (vcu - qcu).size <= 1
            answer = key
            break
          end
        end
      end
    else
      answer = 'unknown who it are'
    end

    uri = URI('https://shakespeare-contest.rubyroidlabs.com/quiz')
    parameters = {
      answer: answer,
      token: 'e205c961bf14c782b3283d25ef008b17',
      task_id: params[:id]
    }
    result = Net::HTTP.post_form(uri, parameters).body

    open("#{Rails.root}/public/index.html", 'a') do |f|
      f << "<tr><td>#{params[:id]}</td><td>#{params[:level]}</td><td>#{params[:question]}</td><td>#{answer}</td><td>#{result}</td></tr>\n"
    end
  end
end
