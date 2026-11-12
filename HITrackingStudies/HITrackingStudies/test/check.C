void check() {
  TFile *f = TFile::Open("OO_trkEff_pixcut.root");
  if (!f || f->IsZombie()) { printf("FILE DID NOT OPEN\n"); return; }
  printf("File opened: %s\n", f->GetName());
  TIter next(f->GetListOfKeys());
  TKey *key;
  printf("--- objects in file ---\n");
  while ((key = (TKey*)next())) {
    TObject *o = key->ReadObj();
    printf("%s  (%s)  entries=%g\n", key->GetName(), o->ClassName(),
           (o->InheritsFrom("TH1")) ? ((TH1*)o)->GetEntries() : -1.0);
  }
}
