import mongoose from 'mongoose';

const cvSectionSchema = new mongoose.Schema(
  {
    type: { type: String, required: true, trim: true },
    title: { type: String, required: true, trim: true, maxlength: 120 },
    data: { type: mongoose.Schema.Types.Mixed, default: {} },
    order: { type: Number, required: true, min: 0 },
  },
  { _id: false },
);

const cvSchema = new mongoose.Schema(
  {
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true, index: true },
    title: { type: String, required: true, trim: true, maxlength: 120 },
    templateId: { type: mongoose.Schema.Types.ObjectId, ref: 'Template' },
    profilePhotoUrl: { type: String, trim: true, maxlength: 2048 },
    links: { type: Map, of: String, default: {} },
    sections: { type: [cvSectionSchema], default: [] },
    completion: { type: Number, default: 0, min: 0, max: 1 },
    isDeleted: { type: Boolean, default: false, index: true },
  },
  { timestamps: true, versionKey: false },
);

cvSchema.index({ userId: 1, updatedAt: -1 });

export const Cv = mongoose.model('Cv', cvSchema);
