
################################################################################
# Copyright (C) 2015  Darrell O. Ricke, PhD
# Author::    	Darrell O. Ricke, Ph.D.  (mailto: Darrell.Ricke@ll.mit.edu)
# Copyright:: 	Copyright (c) 2014 MIT Lincoln Laboratory
# License::   	GNU GPL license  (http://www.gnu.org/licenses/gpl.html)
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
################################################################################

IB::Application.routes.draw do
  
  resources :epoches

  resources :devices

  resources :data_ranges

  resources :data_syncs

  resources :synonyms

  resources :mats

  resources :algorithms

  resources :places do
    member do
      post :show2
    end  # do
  end  # do

  resources :places

  resources :airs

  resources :papers

  resources :atoms

  resources :vocals

  resources :effects

  resources :drug_genes

  resources :drug_reactions

  resources :gene_reactions

  resources :reactions

  resources :pathways

  resources :gos

  resources :locations
  
  resources :monitor_data do
    collection do
      get 'bland_altman'
      get 'surface_map'
      get 'zephyr'
      post 'index2'
      post 'surface_map'
    end  # do
  end  # do

  resources :monitor_data

  resources :instruments

  resources :experiments

  resources :allele_calls

  resources :locus do
    collection do
      get :autocomplete_locu_name
    end  # do
  end  # do

  resources :locus

  resources :alleles

  resources :biosequence_domains

  resources :msas

  resources :aligns

  resources :disease_genes

  resources :domains

  resources :diseases

  resources :variants

  resources :genes
  
  resources :biosequences do
    member do
      get :get_pdb
    end  # do
  end  # do

  resources :biosequences

  resources :structure_sequences
  
  resources :events
  
  resources :ievents

  resources :organisms

  resources :conservations

  resources :sources

  resources :solvents
  
  resources :structures do
    member do
      get :download
      get :get_pdb
    end  # do
  end  # do

  resources :structures

  resources :sicks

  resources :sick_symptoms

  resources :symptoms

  resources :prescriptions

  resources :drugs

  resources :metaprofiles

  resources :gelocations

  resources :group_members

  resources :groups

  resources :group_activities
    
  resources :attachments do
    member do
      get 'download'
      get 'show_image'
      post 'upload'
      post 'fileupload'
      get 'basis'
      post 'basis_load'
      post 'zap'
    end  # do
    collection do
      get 'basis'
      post 'basis_load'
      post 'zap'
      post 'zap2'
    end  # do
  end  # do

  resources :attachments

  resources :ethnics

  resources :ancestries

  resources :measurements

  resources :normals

  resources :notes

  resources :units

  resources :attributes

  resources :events

  resources :itypes
    
  resources :images do
    collection do
      get 'show_img'
      post 'upload'
    end  # do
  end  # do

  resources :images

  resources :meals do
    collection do
      post 'new2'
    end  # do
  end  # do

  resources :meals
  
  resources :activities do
    collection do
      get 'fullcal'
      post 'display'
      get 'return_session'
      post 'json_create'
      post 'json_delete'
      post 'json_update'
      post 'json_resize'
      post 'json_test'
    end  # do
  end  # do

  resources :activities

  resources :panels

  resources :food_items

  resources :individuals
  
  resources :activity_summaries do
    collection do
      post 'index2'
    end  # do
  end  # do

  resources :activity_summaries
  
  resources :foods do
    collection do
      get :autocomplete_food_name
    end  # do
  end  # do

  resources :foods

  resources :drinks

  resources :sleeps do
    collection do
      get 'boxplots'
      get 'bland_altman'
      post 'index2'
    end  # do
  end  # do

  resources :sleeps

  resources :relateds

  resources :families
  
  resources :logins do
    collection do
      get  'logout', 'logins' #, 'change_pw'
      post 'verify', 'change_pw', 'verify_change'
    end  # do
  end  # do
    
  resources :logins
  
  # get "calendar/index"
  
  resources :calendar
  
  root :to => "logins#index"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
